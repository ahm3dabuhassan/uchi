import socket
import threading

PORT = 8080
SERVER = socket.gethostbyname(socket.gethostbyname)
ADDR = (SERVER, PORT)

server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.bind(ADDR)

def handle_client(conn, addr):
    pass

def start():
    server.listen()
    while True:
        conn, addr = server.accept()
        thread = threading.Thread(target=handle_client, args=(conn, addr))


print("[STARTING] server is starting")
start()