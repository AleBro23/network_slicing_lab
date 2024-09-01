# SDN SLICING SU RICHIESTA IN ComNetsEmu
project network slicing using an sdn

## Panoramica:
Il progetto "SDN Slices su Richiesta" è un'implementazione di network slicing utilizzando il controller SDN RYU. Consente l'attivazione e la disattivazione dinamica delle fasce di rete basate sui comandi dell'utente tramite CLI.

## Topologia del Progetto:
La topologia è composta da:
- Switch Core (s1)
- 4 Switch di Distribuzione (s2, s3, s4, s5)
- 8 Host collegati in coppia a ciascun switch di distribuzione.
Ogni switch di distribuzione e i suoi host connessi formano una fascia di rete distinta, progettata per scopi specifici.

## Fasce di Rete e Casi d'Uso:
Immaginando uno scenario realistico, questa rete SDN è configurata per gestire le risorse di una struttura moderna. Le quattro fasce create supportano vari dipartimenti, ognuno con esigenze specifiche.
- **Fascia 1: Laboratorio di Simulazioni Mediche (h1, h2)**
  Questa fascia è utilizzata per simulazioni mediche avanzate, richiedendo una larghezza di banda elevata di 150 Mbps per gestire flussi video in tempo reale e dati sensoriali critici. La latenza deve essere molto bassa per garantire la precisione delle simulazioni.

- **Fascia 2: Sala Conferenze Aziendale (h3, h4)**
  Ottimizzata per videoconferenze e presentazioni dal vivo, questa fascia supporta uno streaming stabile con un bitrate di 100 Mbps. La latenza è moderata per consentire interazioni fluide durante gli incontri.

- **Fascia 3: Laboratorio di Innovazione e Ricerca (h5, h6)**
  Questo laboratorio richiede una connessione affidabile di 120 Mbps per l'accesso a risorse cloud e server di calcolo distribuiti, fondamentali per lo sviluppo di nuovi progetti e prototipi tecnologici.

- **Fascia 4: Centro di Supporto IT (h7, h8)**
  Utilizzato per il monitoraggio della rete e la risoluzione di problemi tecnici, questa fascia ha un bitrate di 50 Mbps. La priorità è la stabilità della connessione piuttosto che la velocità, garantendo un supporto continuo e sicuro per l'intera infrastruttura.

| Fascia   | Funzione                              | Host       | Bitrate (Mbps) | Latenza Prioritaria | Note                                           |
|----------|---------------------------------------|------------|----------------|---------------------|------------------------------------------------|
| Fascia 1 | Laboratorio di Simulazioni Mediche     | h1, h2     | 150            | Sì                  | Simulazioni in tempo reale, alta precisione     |
| Fascia 2 | Sala Conferenze Aziendale              | h3, h4     | 100            | Moderata            | Streaming stabile per videoconferenze           |
| Fascia 3 | Laboratorio di Innovazione e Ricerca   | h5, h6     | 120            | No                  | Accesso a risorse cloud e calcolo distribuito   |
| Fascia 4 | Centro di Supporto IT                  | h7, h8     | 50             | No                  | Monitoraggio della rete e supporto continuo     |


## Installation:

### Requirements
- Mininet
- Ryu SDN Controller
- Open vSwitch (OVS)
- iperf (for testing network performance)

### Step-by-Step Installation

1. **Clone the Repository**
   ```bash
   git clone https://github.com/Erikascaltrito/On_Demand_Slicing.git
   cd On_Demand_Slicing
   
2.	**Install Mininet** Follow the official Mininet installation guide.
3.	**Install Ryu SDN Controller** Install Ryu following the official documentation.
4.	**Setup the Network Topology** Ensure all dependencies are installed, then use the provided Python script to set up the topology.
```bash
   sudo python3 your_topology_script.py


