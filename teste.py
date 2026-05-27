from scapy.all import *

operacao = (1).to_bytes(1, byteorder="big")

t1 = (0x11111111).to_bytes(4, byteorder="big")
t2 = (0x22222222).to_bytes(4, byteorder="big")
t3 = (0x33333333).to_bytes(4, byteorder="big")
t4 = (0x99999999).to_bytes(4, byteorder="big")

segredo = operacao + t1 + t2 + t3 + t4

pkt = Ether(
    dst="00:00:00:00:00:03",
    src="11:11:11:11:11:11",
    type=0x4321
) / Raw(segredo + b"AAAAA")

sendp(pkt, iface="veth0")

operacao = (0).to_bytes(1, byteorder="big")
segredo = operacao + t1 + t2 + t3 + t4
segredo_errado = operacao + t1 + t2 + t3 + t1

pkt1 = Ether(
    dst="00:00:00:00:00:03",
    src="11:11:11:11:11:11",
    type=0x4321
) / Raw(segredo + b"Essa mensagem")

pkt2 = Ether(
    dst="00:00:00:00:00:03",
    src="11:11:11:11:11:11",
    type=0x4321
) / Raw(segredo + b"Definitivamente")

pkt3 = Ether(
    dst="00:00:00:00:00:03",
    src="11:11:11:11:11:11",
    type=0x4321
) / Raw(segredo_errado + b"nao")


pkt4 = Ether(
    dst="00:00:00:00:00:03",
    src="11:11:11:11:11:11",
    type=0x4321
) / Raw(segredo + b"Vale alguma coisa")

sendp(pkt1, iface="veth0")
sendp(pkt2, iface="veth0")
sendp(pkt3, iface="veth0")
sendp(pkt4, iface="veth0")