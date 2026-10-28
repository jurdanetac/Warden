import rumps

from host import Host
from host_monitor import HostMonitor


class WardenApp(rumps.App):
    def __init__(self, hosts: list[Host]):
        super().__init__("Warden")
        self.host_monitor = HostMonitor(hosts=hosts)
        self.host_monitor.start_monitoring()


if __name__ == "__main__":
    localhost = Host(ip="127.0.0.1")
    router = Host(ip="192.168.1.1")
    server = Host(ip="192.168.1.2")
    hosts = [localhost, router, server]

    WardenApp(hosts=hosts).run()
