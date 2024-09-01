# network_slicing_lab
project network slicing using an sdn

Slice 1: Rete Aziendale Interna (Intranet)
Questa slice è dedicata alla comunicazione interna aziendale, con alta priorità e larghezza di banda riservata.

Topologia:

Flusso 1: h1 -> s1 -> s4 -> s2 -> h3
Flusso 2: h2 -> s1 -> s4 -> s2 -> h4
Configurazione:

Larghezza di Banda: 50% riservato su tutti i collegamenti.
QoS: Alta priorità per bassa latenza e alta affidabilità.

slice_intranet:
  topology:
    - link: [h1, s1, 50]
    - link: [s1, s4, 50]
    - link: [s4, s2, 50]
    - link: [s2, h3, 50]
    - link: [h2, s1, 50]
    - link: [s1, s4, 50]
    - link: [s4, s2, 50]
    - link: [s2, h4, 50]
  flows:
    - flow1: {src: h1, dst: h3, bandwidth: 20}
    - flow2: {src: h2, dst: h4, bandwidth: 20}


Slice 2: Rete DMZ (Zona Demilitarizzata)
Questa slice gestisce il traffico tra la rete interna e i server esterni, garantendo sicurezza e isolamento.

Topologia:

Flusso 1: h3 -> s2 -> s4 -> s3 -> h5
Flusso 2: h4 -> s2 -> s4 -> s3 -> h6
Configurazione:

Larghezza di Banda: 30% riservato su tutti i collegamenti.
QoS: Priorità media, con sicurezza e isolamento come obiettivi principali.

slice_dmz:
  topology:
    - link: [h3, s2, 30]
    - link: [s2, s4, 30]
    - link: [s4, s3, 30]
    - link: [s3, h5, 30]
    - link: [h4, s2, 30]
    - link: [s2, s4, 30]
    - link: [s4, s3, 30]
    - link: [s3, h6, 30]
  flows:
    - flow1: {src: h3, dst: h5, bandwidth: 15}
    - flow2: {src: h4, dst: h6, bandwidth: 15}


Slice 3: Rete Pubblica (Accesso Esterno)
Questa slice è destinata al traffico esterno che passa attraverso la rete aziendale, con enfasi sulla capacità e l'accessibilità.

Topologia:

Flusso 1: h5 -> s3 -> s4 -> s1 -> h7
Flusso 2: h6 -> s3 -> s4 -> s1 -> h8
Configurazione:

Larghezza di Banda: 20% riservato su tutti i collegamenti.
QoS: Priorità bassa, con enfasi sulla capacità e l'accesso esterno.

slice_public:
  topology:
    - link: [h5, s3, 20]
    - link: [s3, s4, 20]
    - link: [s4, s1, 20]
    - link: [s1, h7, 20]
    - link: [h6, s3, 20]
    - link: [s3, s4, 20]
    - link: [s4, s1, 20]
    - link: [s1, h8, 20]
  flows:
    - flow1: {src: h5, dst: h7, bandwidth: 10}
    - flow2: {src: h6, dst: h8, bandwidth: 10}
