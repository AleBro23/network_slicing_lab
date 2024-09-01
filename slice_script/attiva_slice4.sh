#!/bin/sh

echo '---------- Riattivazione Slice 4 ----------'

# Riattiva le porte di s5 che sono collegate a h7 e h8 utilizzando ifconfig
sudo ifconfig s5-eth1 up  # Riattiva la porta collegata a h7
sudo ifconfig s5-eth2 up  # Riattiva la porta collegata a h8

# Rimuovi le regole di blocco del traffico tra s5 e s1
sudo ovs-ofctl del-flows s5 "in_port=s5-eth3"
sudo ovs-ofctl del-flows s1 "in_port=s1-eth4"

# Rimuovi ulteriori regole di blocco del traffico in entrata/uscita su s5-eth1 e s5-eth2
sudo ovs-ofctl del-flows s5 "in_port=s5-eth1"
sudo ovs-ofctl del-flows s5 "in_port=s5-eth2"

echo 'Slice 4 riattivata.'
