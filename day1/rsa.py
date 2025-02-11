from Cryptodome.PublicKey import RSA
from Cryptodome.Signature import pkcs1_15
from Cryptodome.Hash import SHA256
import hashlib
import time

def generate_keys():
    key = RSA.generate(2048)
    private_key = key.export_key()
    public_key = key.publickey().export_key()
    return private_key, public_key

def find_pow(prefix, nickname):
    nonce = 0
    while True:
        nonce_str = str(nonce)
        hash_input = nickname + nonce_str
        hash_output = hashlib.sha256(hash_input.encode()).hexdigest()
        
        if hash_output.startswith(prefix):
            return hash_input, hash_output, nonce
        
        nonce += 1

def sign_message(private_key, message):
    key = RSA.import_key(private_key)
    h = SHA256.new(message.encode())
    signature = pkcs1_15.new(key).sign(h)
    return signature

def verify_signature(public_key, message, signature):
    key = RSA.import_key(public_key)
    h = SHA256.new(message.encode())
    try:
        pkcs1_15.new(key).verify(h, signature)
        return True
    except (ValueError, TypeError):
        return False

if __name__ == "__main__":
    nickname = "richard"
    prefix = "0000"

    # Generate RSA keys
    private_key, public_key = generate_keys()
    print("Private Key:", private_key.decode())
    print("Public Key:", public_key.decode())

    # Find a nonce that produces a hash with the required prefix
    start_time = time.time()
    hash_input, hash_output, nonce = find_pow(prefix, nickname)
    end_time = time.time()

    print(f"Time taken: {end_time - start_time} seconds")
    print(f"Hash content: {hash_input}")
    print(f"Hash value: {hash_output}")
    print(f"Nonce: {nonce}")

    # Sign the message with the private key
    signature = sign_message(private_key, hash_input)
    print(f"Signature: {signature.hex()}")

    # Verify the signature with the public key
    is_valid = verify_signature(public_key, hash_input, signature)
    print(f"Signature valid: {is_valid}")