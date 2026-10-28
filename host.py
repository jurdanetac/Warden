from dataclasses import dataclass


@dataclass
class Host:
    """Data class that represents a host in the network"""

    ip: str
    # name: str | None = None
    # mac: str | None = None
