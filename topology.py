from mininet.topo import Topo
from mininet.net import Mininet
from mininet.node import OVSKernelSwitch, RemoteController
from mininet.cli import CLI
from mininet.link import TCLink
from mininet.log import setLogLevel
import subprocess
import os

class SlicingTopo(Topo):
    def __init__(self):
        # Inizializza la topologia
        super(SlicingTopo, self).__init__()  # In Python 3, è buona pratica usare super()

        # Configurazione degli host e dei link
        host_config = dict(inNamespace=True)
        link_config = dict()

        # Creazione dello switch centrale
        core_switch = self.addSwitch('s1', dpid="0000000000000001")

        # Creazione degli switch di distribuzione
        for i in range(4):
            dist_switch = self.addSwitch("s%d" % (i + 2), dpid="%016x" % (i + 2))
            self.addLink(core_switch, dist_switch, **link_config)  # Collegamento tra core switch e distribution switch

            # Creazione di 2 host per ogni switch di distribuzione
            for j in range(2):
                host = self.addHost("h%d" % (2*i + j + 1), **host_config)
                self.addLink(dist_switch, host, **link_config)  # Collegamento tra distribution switch e host

topos = {"networkslicingtopo": (lambda: SlicingTopo())}

if __name__ == "__main__":
    topo = SlicingTopo()
    net = Mininet(
        topo=topo,
        switch=OVSKernelSwitch,
        build=False,
        autoSetMacs=True,
        autoStaticArp=True,
        link=TCLink,
    )

    setLogLevel("info")

    controller = RemoteController("c0", ip="127.0.0.1", port=6633)
    net.addController(controller)
    net.build()
    net.start()

    # Attivazione del server UDP su slice 2 (se applicabile)
    udp_servers = ["h3", "h4"]

    for h in net.hosts:
        if h.name in udp_servers:
            h.cmd('iperf -s -u -p 5050 &')

    # Path dello script
    script_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "slice_script","attiva_slicing.sh")

    # Esegue lo script bash e cattura l'output
    try:
        exit_code = subprocess.call(script_path)
        
        if exit_code == 0:
            print("Script {} eseguito con successo.".format(script_path))
        else:
            print("Errore nell'esecuzione dello script {}. Codice di uscita: {}".format(exit_code))
    except OSError as e:
        print("Errore nell'esecuzione dello script {}: {}".format(script_path, e)) 

    CLI(net)
    net.stop()
