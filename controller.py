# Importazioni necessarie dalle librerie Ryu e Python
from ryu.base import app_manager
from ryu.controller import ofp_event
from ryu.controller.handler import CONFIG_DISPATCHER, MAIN_DISPATCHER
from ryu.controller.handler import set_ev_cls
from ryu.ofproto import ofproto_v1_3
from ryu.lib.packet import packet
from ryu.lib.packet import ethernet
from ryu.lib.packet import ether_types
import subprocess
import threading
import time
import os

# Definizione della classe TrafficSlicing, un'applicazione Ryu (controller)
class TrafficSlicing(app_manager.RyuApp):
    OFP_VERSIONS = [ofproto_v1_3.OFP_VERSION]

    def __init__(self, *args, **kwargs):
        super(TrafficSlicing, self).__init__(*args, **kwargs)

        # Mapping destinazioni [switch --> MAC Destinazione --> Porta Ethernet di Uscita]
        self.mac_to_port = {
            # Core Switch s1
            1: {
                "00:00:00:00:01:01": 2,  # h1 is reachable via s2 (port 2)
                "00:00:00:00:01:02": 2,  # h2 is reachable via s2 (port 2)
                "00:00:00:00:02:01": 3,  # h3 is reachable via s3 (port 3)
                "00:00:00:00:02:02": 3,  # h4 is reachable via s3 (port 3)
                "00:00:00:00:03:01": 4,  # h5 is reachable via s4 (port 4)
                "00:00:00:00:03:02": 4,  # h6 is reachable via s4 (port 4)
                "00:00:00:00:04:01": 5,  # h7 is reachable via s5 (port 5)
                "00:00:00:00:04:02": 5   # h8 is reachable via s5 (port 5)
            },
            # Distribution Switch s2
            2: {
                "00:00:00:00:01:01": 1,  # h1 is connected to port 1 of s2
                "00:00:00:00:01:02": 2   # h2 is connected to port 2 of s2
            },
            # Distribution Switch s3
            3: {
                "00:00:00:00:02:01": 1,  # h3 is connected to port 1 of s3
                "00:00:00:00:02:02": 2   # h4 is connected to port 2 of s3
            },
            # Distribution Switch s4
            4: {
                "00:00:00:00:03:01": 1,  # h5 is connected to port 1 of s4
                "00:00:00:00:03:02": 2   # h6 is connected to port 2 of s4
            },
            # Distribution Switch s5
            5: {
                "00:00:00:00:04:01": 1,  # h7 is connected to port 1 of s5
                "00:00:00:00:04:02": 2   # h8 is connected to port 2 of s5
            }
        }

    # Gestisce l'evento quando lo switch si connette al controller e invia le sue caratteristiche.
    @set_ev_cls(ofp_event.EventOFPSwitchFeatures, CONFIG_DISPATCHER)
    def switch_features_handler(self, ev):
        datapath = ev.msg.datapath
        ofproto = datapath.ofproto # Ottiene il protocollo OpenFlow dello switch
        parser = datapath.ofproto_parser

        # Installazione di una regola di default per il table-miss
        match = parser.OFPMatch() # Crea un match vuoto (regola di default)
        actions = [
            parser.OFPActionOutput(ofproto.OFPP_CONTROLLER, ofproto.OFPCML_NO_BUFFER)
        ] 
        self.add_flow(datapath, 0, match, actions) # Aggiunge la regola al flow table

    # Funzione per aggiungere una nuova regola al flow table (tabella dei flussi dello switch)
    def add_flow(self, datapath, priority, match, actions):
        ofproto = datapath.ofproto
        parser = datapath.ofproto_parser

        # Crea l'istruzione per applicare le azioni ai pacchetti
        inst = [parser.OFPInstructionActions(ofproto.OFPIT_APPLY_ACTIONS, actions)]
        # Crea il messaggio flow_mod per inviare la regola al datapath
        mod = parser.OFPFlowMod(
            datapath=datapath, priority=priority, match=match, instructions=inst
        )
        datapath.send_msg(mod) # Invia la regola allo switch

    # Gestore dell'evento PacketIn (quando un pacchetto arriva al controller)
    @set_ev_cls(ofp_event.EventOFPPacketIn, MAIN_DISPATCHER)
    def _packet_in_handler(self, ev):
        msg = ev.msg
        datapath = msg.datapath
        in_port = msg.match['in_port']

        pkt = packet.Packet(msg.data)
        eth = pkt.get_protocol(ethernet.ethernet) # Ottiene il livello Ethernet del pacchetto
        if eth.ethertype == ether_types.ETH_TYPE_LLDP:
            # Ignora i pacchetti LLDP (protocollo usato per scoprire la topologia della rete)
            return

        dst = eth.dst
        src = eth.src
        dpid = datapath.id

        # Verifica se il controller conosce lo switch corrente (dpid).
        if dpid in self.mac_to_port:
            # Se la destinazione è conosciuta invio il pacchetto al MAC di destinazione
            if dst in self.mac_to_port[dpid]:
                out_port = self.mac_to_port[dpid][dst]
                actions = [datapath.ofproto_parser.OFPActionOutput(out_port)]
                match = datapath.ofproto_parser.OFPMatch(eth_dst=dst)
                self.add_flow(datapath, 1, match, actions)
                self._send_package(msg, datapath, in_port, actions)
            else:
                # Se la destinazione non è conosciuta, instrada il pacchetto a tutte le porte
                out_port = datapath.ofproto.OFPP_FLOOD
                actions = [datapath.ofproto_parser.OFPActionOutput(out_port)]
                self._send_package(msg, datapath, in_port, actions)

    # Instrada un pacchetto dallo switch alla destinazione
    def _send_package(self, msg, datapath, in_port, actions):
        data = None
        ofproto = datapath.ofproto
        if msg.buffer_id == ofproto.OFP_NO_BUFFER:
            data = msg.data

        out = datapath.ofproto_parser.OFPPacketOut(
            datapath=datapath,
            buffer_id=msg.buffer_id,
            in_port=in_port,
            actions=actions,
            data=data,
        )
        datapath.send_msg(out)
