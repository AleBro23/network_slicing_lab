from ryu.base import app_manager
from ryu.controller.event import EventBase
from ryu.controller.controller import Datapath
from ryu.controller.handler import set_ev_cls, CONFIG_DISPATCHER
from ryu.ofproto import ofproto_v1_3

class MyCustomSliceDeactivationEvent(EventBase):
    def __init__(self, slice_id):
        self.slice_id = slice_id

class SliceManager(app_manager.RyuApp):
    OFP_VERSIONS = [ofproto_v1_3.OFP_VERSION]

    def __init__(self, *args, **kwargs):
        super(SliceManager, self).__init__(*args, **kwargs)

    def deactivate_slice(self, slice_id):
        deactivation_event = MyCustomSliceDeactivationEvent(slice_id)
        self.send_event_to_observers(deactivation_event)

if __name__ == '__main__':
    app = SliceManager()
    app.deactivate_slice(3)  # Disattiva la slice con ID 3