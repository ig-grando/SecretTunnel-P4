from scapy.all import Ether, Raw, sendp

# cria pacote ethernet simples
pkt = Ether(
    dst="00:00:00:00:00:04",   # deve sair na porta 3 (veth16)
    src="11:11:11:11:11:11"
) / Raw(b"hello")

print("Enviando pacote...")
pkt.show()

sendp(pkt, iface="veth0")
print("Enviado!")
