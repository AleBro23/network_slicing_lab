from ryu.base import app_manager
from ryu.controller import ofp_event
from ryu.controller.handler import CONFIG_DISPATCHER, MAIN_DISPATCHER
from ryu.controller.handler import set_ev_cls
from ryu.ofproto import ofproto_v1_3
from ryu.controller.event import EventBase

class MyCustomSliceActivationEvent(EventBase):
    def __init__(self, slice_id):
        self.slice_id = slice_id

class MyCustomSliceDeactivationEvent(EventBase):
    def __init__(self, slice_id):
        self.slice_id = slice_id

class SliceManager(app_manager.RyuApp):
    OFP_VERSIONS = [ofproto_v1_3.OFP_VERSION]

    def __init__(self, *args, **kwargs):
        super(SliceManager, self).__init__(*args, **kwargs)
        # Inizializza lo stato delle slice
        self.slice_enabled = [True, True, True]
        self.activate_all_slices()

    def activate_all_slices(self):
        self.slice_enabled = [True, True, True]
        self.logger.info("Tutte le slice attivate all'avvio")

    def activate_slice(self, slice_id):
        if slice_id == 2 or slice_id == 3:
            if self.slice_enabled[slice_id]:
                self.logger.error("Slice {} già attiva".format(slice_id))
            else:
                self.slice_enabled[slice_id] = True
                self.logger.info("Slice {} attivata".format(slice_id))
        else:
            self.logger.error("ID slice non valido")

    def deactivate_slice(self, slice_id):
        if slice_id == 2 or slice_id == 3:
            if not self.slice_enabled[slice_id]:
                self.logger.error("Slice {} già disattivata".format(slice_id))
            else:
                self.slice_enabled[slice_id] = False
                self.logger.info("Slice {} disattivata".format(slice_id))
        else:
            self.logger.error("ID slice non valido")

    @set_ev_cls(MyCustomSliceActivationEvent)
    def slice_activation_handler(self, ev):
        self.activate_slice(ev.slice_id)

    @set_ev_cls(MyCustomSliceDeactivationEvent)
    def slice_deactivation_handler(self, ev):
        self.deactivate_slice(ev.slice_id)