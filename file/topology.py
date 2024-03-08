#!/usr/bin/env python3

from mininet.topo import Topo
from mininet.node import RemoteController, OVSKernelSwitch
from mininet.net import Mininet
from mininet.link import TCLink
from mininet.cli import CLI


class MyTopology(Topo): #init topolgy
    def __init__(self): 
        Topo.__init__(self)
        #slice definition
        host_config_slice1 = dict(inNamespace=True) 
        host_config_slice2 = dict(inNamespace=True) 
        host_config_slice3 = dict(inNamespace=True) 
        #dict per collegare host e switch
        host_link_config = dict()
        #dict per collegare switch e switch
        switch_link_config = dict()
        
        #add switch
        for i in range (4):
            sconfig = {"dpid": "%016x" % (i+1)}
            self.addSwitch("s%d" % (i+1), **sconfig) #openflow???

        #add host in every slice
        #slice1
        for i in range(4): 
            self.addHost('h1{}'.format(i+1), **host_config_slice1)
        #slice 2
        for i in range(2): 
            self.addHost('h2{}'.format(i+1), **host_config_slice2) #slice2
        #slice3
        self.addHost('h31', **host_config_slice3)
    
        #add link between host and switches
        self.addLink('h11', 's1', **host_link_config)
        self.addLink('h12', 's1', **host_link_config)
        self.addLink('h13', 's2', **host_link_config)
        self.addLink('h14', 's2', **host_link_config)
        self.addLink('h21', 's3', **host_link_config)
        self.addLink('h22', 's3', **host_link_config)
        self.addLink('h31', 's4', **host_link_config)

        #add link between switch and switch
        self.addLink('s1', 's2', switch_link_config)
        self.addLink('s1', 's3', switch_link_config)
        self.addLink('s1', 's4', switch_link_config)
        self.addLink('s2', 's3', switch_link_config)
        self.addLink('s2', 's4', switch_link_config)

