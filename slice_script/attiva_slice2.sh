#!/bin/sh

echo '---------- Riattivazione Slice 2 ----------'

# Riattiva le porte di s3 che sono collegate a h3 e h4 utilizzando ifconfig
sudo ifconfig s3-eth1 up  # Riattiva la porta collegata a h3
sudo ifconfig s3-eth2 up  # Riattiva la porta collegata a h4

# Rimuovi le regole di blocco del traffico tra s3 e s1
sudo ovs-ofctl del-flows s3 "in_port=s3-eth3"
sudo ovs-ofctl del-flows s1 "in_port=s1-eth2"

# Rimuovi ulteriori regole di blocco del traffico in entrata/uscita su s3-eth1 e s3-eth2
sudo ovs-ofctl del-flows s3 "in_port=s3-eth1"
sudo ovs-ofctl del-flows s3 "in_port=s3-eth2"

echo 'Slice 2 riattivata.'
