#!/bin/sh

echo '---------- Riattivazione Slice 1 ----------'

# Riattiva le porte di s2 che sono collegate a h1 e h2 utilizzando ifconfig
sudo ifconfig s2-eth1 up  # Riattiva la porta collegata a h1
sudo ifconfig s2-eth2 up  # Riattiva la porta collegata a h2

# Rimuovi le regole di blocco del traffico tra s2 e s1
sudo ovs-ofctl del-flows s2 "in_port=s2-eth3"
sudo ovs-ofctl del-flows s1 "in_port=s1-eth1"

# Rimuovi ulteriori regole di blocco del traffico in entrata/uscita su s2-eth1 e s2-eth2
sudo ovs-ofctl del-flows s2 "in_port=s2-eth1"
sudo ovs-ofctl del-flows s2 "in_port=s2-eth2"

echo 'Slice 1 riattivata.'
