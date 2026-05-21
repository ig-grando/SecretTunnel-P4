from scapy.all import *

operacao = (1).to_bytes(1, byteorder="big")

token = (0x11111111111111111111111111111111).to_bytes(16, byteorder="big")

segredo = operacao + token

pkt = Ether(
    dst="00:00:00:00:00:03",
    src="11:11:11:11:11:11",
    type=0x4321
) / Raw(segredo + b"hello")

sendp(pkt, iface="veth0")