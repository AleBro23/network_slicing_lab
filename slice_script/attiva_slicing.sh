#!/bin/sh

echo '---------- Riattivazione di Tutte le Slice ----------'

# Riattiva le porte disabilitate su s2, s3, s4, s5
sudo ifconfig s2-eth1 up  # Riattiva la porta collegata a h1
sudo ifconfig s2-eth2 up  # Riattiva la porta collegata a h2
sudo ifconfig s3-eth1 up  # Riattiva la porta collegata a h3
sudo ifconfig s3-eth2 up  # Riattiva la porta collegata a h4
sudo ifconfig s4-eth1 up  # Riattiva la porta collegata a h5
sudo ifconfig s4-eth2 up  # Riattiva la porta collegata a h6
sudo ifconfig s5-eth1 up  # Riattiva la porta collegata a h7
sudo ifconfig s5-eth2 up  # Riattiva la porta collegata a h8

# Rimuovi le regole di blocco del traffico tra gli switch di distribuzione e lo switch centrale
sudo ovs-ofctl del-flows s2 "in_port=s2-eth3"
sudo ovs-ofctl del-flows s1 "in_port=s1-eth1"
sudo ovs-ofctl del-flows s3 "in_port=s3-eth3"
sudo ovs-ofctl del-flows s1 "in_port=s1-eth2"
sudo ovs-ofctl del-flows s4 "in_port=s4-eth3"
sudo ovs-ofctl del-flows s1 "in_port=s1-eth3"
sudo ovs-ofctl del-flows s5 "in_port=s5-eth3"
sudo ovs-ofctl del-flows s1 "in_port=s1-eth4"

# Rimuovi le regole di blocco sulle porte specifiche degli host su s2, s3, s4, s5
sudo ovs-ofctl del-flows s2 "in_port=s2-eth1"
sudo ovs-ofctl del-flows s2 "in_port=s2-eth2"
sudo ovs-ofctl del-flows s3 "in_port=s3-eth1"
sudo ovs-ofctl del-flows s3 "in_port=s3-eth2"
sudo ovs-ofctl del-flows s4 "in_port=s4-eth1"
sudo ovs-ofctl del-flows s4 "in_port=s4-eth2"
sudo ovs-ofctl del-flows s5 "in_port=s5-eth1"
sudo ovs-ofctl del-flows s5 "in_port=s5-eth2"


# Configurazione QoS specifica per ogni fascia
# Fascia 1: Laboratorio di Simulazioni Mediche (h1, h2) - 150 Mbps, latenza molto bassa
sudo ovs-vsctl set port s2-eth1 qos=@newqos -- \
    --id=@newqos create QoS type=linux-htb \
    other-config:max-rate=150000000 \ 
    queues:1=@1q -- \
    --id=@1q create queue other-config:min-rate=140000000 other-config:max-rate=150000000 >/dev/null #coda

sudo ovs-vsctl set port s2-eth2 qos=@newqos -- \
    --id=@newqos create QoS type=linux-htb \
    other-config:max-rate=150000000 \
    queues:2=@2q -- \
    --id=@2q create queue other-config:min-rate=140000000 other-config:max-rate=150000000 >/dev/null

# Fascia 2: Sala Conferenze Aziendale (h3, h4) - 100 Mbps, latenza moderata
sudo ovs-vsctl set port s3-eth1 qos=@newqos -- \
    --id=@newqos create QoS type=linux-htb \
    other-config:max-rate=100000000 \
    queues:3=@3q -- \
    --id=@3q create queue other-config:min-rate=90000000 other-config:max-rate=100000000 >/dev/null

sudo ovs-vsctl set port s3-eth2 qos=@newqos -- \
    --id=@newqos create QoS type=linux-htb \
    other-config:max-rate=100000000 \
    queues:4=@4q -- \
    --id=@4q create queue other-config:min-rate=90000000 other-config:max-rate=100000000 >/dev/null

# Fascia 3: Laboratorio di Innovazione e Ricerca (h5, h6) - 120 Mbps, connessione affidabile
sudo ovs-vsctl set port s4-eth1 qos=@newqos -- \
    --id=@newqos create QoS type=linux-htb \
    other-config:max-rate=120000000 \
    queues:5=@5q -- \
    --id=@5q create queue other-config:min-rate=110000000 other-config:max-rate=120000000 >/dev/null

sudo ovs-vsctl set port s4-eth2 qos=@newqos -- \
    --id=@newqos create QoS type=linux-htb \
    other-config:max-rate=120000000 \
    queues:6=@6q -- \
    --id=@6q create queue other-config:min-rate=110000000 other-config:max-rate=120000000 >/dev/null

# Fascia 4: Centro di Supporto IT (h7, h8) - 50 Mbps, stabilita' della connessione
sudo ovs-vsctl set port s5-eth1 qos=@newqos -- \
    --id=@newqos create QoS type=linux-htb \
    other-config:max-rate=50000000 \
    queues:7=@7q -- \
    --id=@7q create queue other-config:min-rate=50000000 other-config:max-rate=50000000 >/dev/null

sudo ovs-vsctl set port s5-eth2 qos=@newqos -- \
    --id=@newqos create QoS type=linux-htb \
    other-config:max-rate=50000000 \
    queues:8=@8q -- \
    --id=@8q create queue other-config:min-rate=50000000 other-config:max-rate=50000000 >/dev/null

# Regole di flusso per comunicazione tra tutti gli host

#FASCIA 1
# Flussi da h1 a tutti gli altri host
sudo ovs-ofctl add-flow s2 ip,priority=65500,nw_src=10.0.0.1,nw_dst=10.0.0.2,idle_timeout=0,actions=set_queue:1,normal
sudo ovs-ofctl add-flow s2 ip,priority=65500,nw_src=10.0.0.1,nw_dst=10.0.0.3,idle_timeout=0,actions=set_queue:1,normal
sudo ovs-ofctl add-flow s2 ip,priority=65500,nw_src=10.0.0.1,nw_dst=10.0.0.4,idle_timeout=0,actions=set_queue:1,normal
sudo ovs-ofctl add-flow s2 ip,priority=65500,nw_src=10.0.0.1,nw_dst=10.0.0.5,idle_timeout=0,actions=set_queue:1,normal
sudo ovs-ofctl add-flow s2 ip,priority=65500,nw_src=10.0.0.1,nw_dst=10.0.0.6,idle_timeout=0,actions=set_queue:1,normal
sudo ovs-ofctl add-flow s2 ip,priority=65500,nw_src=10.0.0.1,nw_dst=10.0.0.7,idle_timeout=0,actions=set_queue:1,normal
sudo ovs-ofctl add-flow s2 ip,priority=65500,nw_src=10.0.0.1,nw_dst=10.0.0.8,idle_timeout=0,actions=set_queue:1,normal

# Flussi da h2 a tutti gli altri host
sudo ovs-ofctl add-flow s2 ip,priority=65500,nw_src=10.0.0.2,nw_dst=10.0.0.1,idle_timeout=0,actions=set_queue:2,normal
sudo ovs-ofctl add-flow s2 ip,priority=65500,nw_src=10.0.0.2,nw_dst=10.0.0.3,idle_timeout=0,actions=set_queue:2,normal
sudo ovs-ofctl add-flow s2 ip,priority=65500,nw_src=10.0.0.2,nw_dst=10.0.0.4,idle_timeout=0,actions=set_queue:2,normal
sudo ovs-ofctl add-flow s2 ip,priority=65500,nw_src=10.0.0.2,nw_dst=10.0.0.5,idle_timeout=0,actions=set_queue:2,normal
sudo ovs-ofctl add-flow s2 ip,priority=65500,nw_src=10.0.0.2,nw_dst=10.0.0.6,idle_timeout=0,actions=set_queue:2,normal
sudo ovs-ofctl add-flow s2 ip,priority=65500,nw_src=10.0.0.2,nw_dst=10.0.0.7,idle_timeout=0,actions=set_queue:2,normal
sudo ovs-ofctl add-flow s2 ip,priority=65500,nw_src=10.0.0.2,nw_dst=10.0.0.8,idle_timeout=0,actions=set_queue:2,normal


#FASCIA 2
# Flussi da h3 a tutti gli altri host 
sudo ovs-ofctl add-flow s3 ip,priority=65500,nw_src=10.0.0.3,nw_dst=10.0.0.1,idle_timeout=0,actions=set_queue:3,normal
sudo ovs-ofctl add-flow s3 ip,priority=65500,nw_src=10.0.0.3,nw_dst=10.0.0.2,idle_timeout=0,actions=set_queue:3,normal
sudo ovs-ofctl add-flow s3 ip,priority=65500,nw_src=10.0.0.3,nw_dst=10.0.0.4,idle_timeout=0,actions=set_queue:3,normal
sudo ovs-ofctl add-flow s3 ip,priority=65500,nw_src=10.0.0.3,nw_dst=10.0.0.5,idle_timeout=0,actions=set_queue:3,normal
sudo ovs-ofctl add-flow s3 ip,priority=65500,nw_src=10.0.0.3,nw_dst=10.0.0.6,idle_timeout=0,actions=set_queue:3,normal
sudo ovs-ofctl add-flow s3 ip,priority=65500,nw_src=10.0.0.3,nw_dst=10.0.0.7,idle_timeout=0,actions=set_queue:3,normal
sudo ovs-ofctl add-flow s3 ip,priority=65500,nw_src=10.0.0.3,nw_dst=10.0.0.8,idle_timeout=0,actions=set_queue:3,normal

# Flussi da h4 a tutti gli altri host 
sudo ovs-ofctl add-flow s3 ip,priority=65500,nw_src=10.0.0.4,nw_dst=10.0.0.1,idle_timeout=0,actions=set_queue:4,normal
sudo ovs-ofctl add-flow s3 ip,priority=65500,nw_src=10.0.0.4,nw_dst=10.0.0.2,idle_timeout=0,actions=set_queue:4,normal
sudo ovs-ofctl add-flow s3 ip,priority=65500,nw_src=10.0.0.4,nw_dst=10.0.0.3,idle_timeout=0,actions=set_queue:4,normal
sudo ovs-ofctl add-flow s3 ip,priority=65500,nw_src=10.0.0.4,nw_dst=10.0.0.5,idle_timeout=0,actions=set_queue:4,normal
sudo ovs-ofctl add-flow s3 ip,priority=65500,nw_src=10.0.0.4,nw_dst=10.0.0.6,idle_timeout=0,actions=set_queue:4,normal
sudo ovs-ofctl add-flow s3 ip,priority=65500,nw_src=10.0.0.4,nw_dst=10.0.0.7,idle_timeout=0,actions=set_queue:4,normal
sudo ovs-ofctl add-flow s3 ip,priority=65500,nw_src=10.0.0.4,nw_dst=10.0.0.8,idle_timeout=0,actions=set_queue:4,normal


#FASCIA 3
# Flussi da h5 a tutti gli altri host 
sudo ovs-ofctl add-flow s4 ip,priority=65500,nw_src=10.0.0.5,nw_dst=10.0.0.1,idle_timeout=0,actions=set_queue:5,normal
sudo ovs-ofctl add-flow s4 ip,priority=65500,nw_src=10.0.0.5,nw_dst=10.0.0.2,idle_timeout=0,actions=set_queue:5,normal
sudo ovs-ofctl add-flow s4 ip,priority=65500,nw_src=10.0.0.5,nw_dst=10.0.0.3,idle_timeout=0,actions=set_queue:5,normal
sudo ovs-ofctl add-flow s4 ip,priority=65500,nw_src=10.0.0.5,nw_dst=10.0.0.4,idle_timeout=0,actions=set_queue:5,normal
sudo ovs-ofctl add-flow s4 ip,priority=65500,nw_src=10.0.0.5,nw_dst=10.0.0.6,idle_timeout=0,actions=set_queue:5,normal
sudo ovs-ofctl add-flow s4 ip,priority=65500,nw_src=10.0.0.5,nw_dst=10.0.0.7,idle_timeout=0,actions=set_queue:5,normal
sudo ovs-ofctl add-flow s4 ip,priority=65500,nw_src=10.0.0.5,nw_dst=10.0.0.8,idle_timeout=0,actions=set_queue:5,normal

# Flussi da h6 a tutti gli altri host 
sudo ovs-ofctl add-flow s4 ip,priority=65500,nw_src=10.0.0.6,nw_dst=10.0.0.1,idle_timeout=0,actions=set_queue:6,normal
sudo ovs-ofctl add-flow s4 ip,priority=65500,nw_src=10.0.0.6,nw_dst=10.0.0.2,idle_timeout=0,actions=set_queue:6,normal
sudo ovs-ofctl add-flow s4 ip,priority=65500,nw_src=10.0.0.6,nw_dst=10.0.0.3,idle_timeout=0,actions=set_queue:6,normal
sudo ovs-ofctl add-flow s4 ip,priority=65500,nw_src=10.0.0.6,nw_dst=10.0.0.4,idle_timeout=0,actions=set_queue:6,normal
sudo ovs-ofctl add-flow s4 ip,priority=65500,nw_src=10.0.0.6,nw_dst=10.0.0.5,idle_timeout=0,actions=set_queue:6,normal
sudo ovs-ofctl add-flow s4 ip,priority=65500,nw_src=10.0.0.6,nw_dst=10.0.0.7,idle_timeout=0,actions=set_queue:6,normal
sudo ovs-ofctl add-flow s4 ip,priority=65500,nw_src=10.0.0.6,nw_dst=10.0.0.8,idle_timeout=0,actions=set_queue:6,normal


#FASCIA 4
# Flussi da h7 a tutti gli altri host 
sudo ovs-ofctl add-flow s5 ip,priority=65500,nw_src=10.0.0.7,nw_dst=10.0.0.1,idle_timeout=0,actions=set_queue:7,normal
sudo ovs-ofctl add-flow s5 ip,priority=65500,nw_src=10.0.0.7,nw_dst=10.0.0.2,idle_timeout=0,actions=set_queue:7,normal
sudo ovs-ofctl add-flow s5 ip,priority=65500,nw_src=10.0.0.7,nw_dst=10.0.0.3,idle_timeout=0,actions=set_queue:7,normal
sudo ovs-ofctl add-flow s5 ip,priority=65500,nw_src=10.0.0.7,nw_dst=10.0.0.4,idle_timeout=0,actions=set_queue:7,normal
sudo ovs-ofctl add-flow s5 ip,priority=65500,nw_src=10.0.0.7,nw_dst=10.0.0.5,idle_timeout=0,actions=set_queue:7,normal
sudo ovs-ofctl add-flow s5 ip,priority=65500,nw_src=10.0.0.7,nw_dst=10.0.0.6,idle_timeout=0,actions=set_queue:7,normal
sudo ovs-ofctl add-flow s5 ip,priority=65500,nw_src=10.0.0.7,nw_dst=10.0.0.8,idle_timeout=0,actions=set_queue:7,normal

# Flussi da h8 a tutti gli altri host (Fascia 4)
sudo ovs-ofctl add-flow s5 ip,priority=65500,nw_src=10.0.0.8,nw_dst=10.0.0.1,idle_timeout=0,actions=set_queue:8,normal
sudo ovs-ofctl add-flow s5 ip,priority=65500,nw_src=10.0.0.8,nw_dst=10.0.0.2,idle_timeout=0,actions=set_queue:8,normal
sudo ovs-ofctl add-flow s5 ip,priority=65500,nw_src=10.0.0.8,nw_dst=10.0.0.3,idle_timeout=0,actions=set_queue:8,normal
sudo ovs-ofctl add-flow s5 ip,priority=65500,nw_src=10.0.0.8,nw_dst=10.0.0.4,idle_timeout=0,actions=set_queue:8,normal
sudo ovs-ofctl add-flow s5 ip,priority=65500,nw_src=10.0.0.8,nw_dst=10.0.0.5,idle_timeout=0,actions=set_queue:8,normal
sudo ovs-ofctl add-flow s5 ip,priority=65500,nw_src=10.0.0.8,nw_dst=10.0.0.6,idle_timeout=0,actions=set_queue:8,normal
sudo ovs-ofctl add-flow s5 ip,priority=65500,nw_src=10.0.0.8,nw_dst=10.0.0.7,idle_timeout=0,actions=set_queue:8,normal


echo 'Tutte le slice sono state attivate.'
