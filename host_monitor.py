import asyncio
import platform
import subprocess
import threading

from host import Host


class HostMonitor:
    """Class for monitoring a list of hosts continuously in the background."""

    def __init__(self, hosts: list[Host]):
        self.hosts = hosts
        self._interval = 5  # Seconds to wait between sweeps
        self._max_concurrency = 50
        self._stop_event = threading.Event()
        self._thread: threading.Thread | None = None

    def start_monitoring(self):
        """Starts the continuous background monitoring loop."""
        if self._thread and self._thread.is_alive():
            print("Monitoring is already active.")
            return

        self._stop_event.clear()
        self._thread = threading.Thread(target=self._run_async_loop, daemon=True)
        self._thread.start()

    def stop_monitoring(self):
        """Signals the background loop to stop immediately."""
        self._stop_event.set()
        if self._thread and self._thread.is_alive():
            self._thread.join(timeout=self._interval + 2)

    def _run_async_loop(self):
        """Entry point for the background thread."""
        asyncio.run(self._monitor_loop())

    async def _monitor_loop(self):
        """Runs on the background thread until _stop_event is set."""
        semaphore = asyncio.Semaphore(self._max_concurrency)

        async def semaphore_ping(host: Host):
            if self._stop_event.is_set():
                return host.ip, False
            async with semaphore:
                is_up = await self._ping(host)
                print(f"{host.ip}: {'UP' if is_up else 'DOWN'}")
                return host.ip, is_up

        while not self._stop_event.is_set():
            await asyncio.gather(*(semaphore_ping(h) for h in self.hosts))

            # Wait for the interval, or wake up immediately if stop_monitoring() is called
            try:
                await asyncio.to_thread(self._stop_event.wait, self._interval)
            except Exception:
                break

    async def _ping(self, host: Host) -> bool:
        """Pings a single host asynchronously with a Python-managed timeout."""
        count_flag = "-n" if platform.system().lower() == "windows" else "-c"
        command = ["ping", count_flag, "1", host.ip]

        process = None
        try:
            process = await asyncio.create_subprocess_exec(
                *command,
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
            )
            await asyncio.wait_for(process.wait(), timeout=1.0)
            return process.returncode == 0
        except asyncio.TimeoutError:
            if process:
                process.kill()
                await process.wait()
            return False
        except Exception:
            return False
