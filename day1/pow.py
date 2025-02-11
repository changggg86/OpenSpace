import hashlib
import time

def mine(nickname, prefix):
    nonce = 0
    print("-" * 50)
    print(f"昵称：{nickname}，前缀：{prefix}")
    
    start_time = time.time()
    
    while True:
        nonce_str = str(nonce)
        hash_input = nickname + nonce_str
        hash_output = hashlib.sha256(hash_input.encode()).hexdigest()
        
        if hash_output.startswith(prefix):
            end_time = time.time()
            elapsed_time = end_time - start_time
            print(f"耗时: {elapsed_time} seconds")
            print(f"哈希内容: {hash_input}")
            print(f"哈希值: {hash_output}")
            print(f"Nonce值: {nonce}")
            break
        
        nonce += 1

if __name__ == "__main__":
    mine("richard", "0000")  # 昵称：richard，前缀：0000
    mine("richard", "00000")  # 昵称：richard，前缀：00000