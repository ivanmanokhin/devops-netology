import os
import sys
import json
import time
from datetime import datetime

metrics_dir = '/proc'
today = datetime.today().strftime('%y-%m-%d')
log_file = f'/var/log/{today}-awesome-monitoring.log'

# собираем метрики из файлов в директории /proc
loadavg = {}
with open('/proc/loadavg') as f:
    la = f.read().strip().split()
    loadavg['1'] = float(la[0])
    loadavg['5'] = float(la[1])
    loadavg['15'] = float(la[2])

ram = {}
with open(os.path.join(metrics_dir, 'meminfo'), 'r') as f:
    for line in f:
        if line.startswith('MemTotal:'):
            ram['total'] = int(line.split()[1])
        elif line.startswith('MemAvailable:'):
            ram['available'] = int(line.split()[1])
        elif line.startswith('MemFree:'):
            ram['free'] = int(line.split()[1])
        elif line.startswith('Buffers:'):
            ram['buffers'] = int(line.split()[1])
        elif line.startswith('Cached:'):
            ram['cached'] = int(line.split()[1])
        elif line.startswith('SwapTotal:'):
            ram['swap_total'] = int(line.split()[1])
        elif line.startswith('SwapFree:'):
            ram['swap_free'] = int(line.split()[1])

disk = {}
with open(os.path.join(metrics_dir, 'diskstats'), 'r') as f:
    for line in f:
        stats = line.strip().split()
        dev = stats[2]
        reads = int(stats[3])
        reads_merged = int(stats[4])
        read_sectors = int(stats[5])
        read_ms = int(stats[6])
        writes = int(stats[7])
        writes_merged = int(stats[8])
        write_sectors = int(stats[9])
        write_ms = int(stats[10])
        io_in_progress = int(stats[11])
        io_ms = int(stats[12])
        weighted_io_ms = int(stats[13])

        if dev.startswith('sd') or dev.startswith('hd') or dev.startswith('vd'):
            disk[dev] = {
                'reads': reads,
                'writes': writes,
                'read_sectors': read_sectors,
                'write_sectors': write_sectors
            }

network = {}
with open(os.path.join(metrics_dir, 'net/dev'), 'r') as f:
    for line in f:
        if line.strip().startswith(('Inter', 'face', 'lo')):
            continue
        interface, stats = line.strip().split(':')
        stats = stats.split()
        network[interface] = {
            'rx_bytes': int(stats[0]),
            'rx_packets': int(stats[1]),
            'rx_errors': int(stats[2]),
            'rx_dropped': int(stats[3]),
            'tx_bytes': int(stats[8]),
            'tx_packets': int(stats[9]),
            'tx_errors': int(stats[10]),
            'tx_dropped': int(stats[11]),
        }

# записываем метрики в файл
with open(log_file, 'a') as f:
    timestamp = int(time.time())
    data = {'timestamp': timestamp, 'loadavg': loadavg, 'ram': ram, 'disk': disk, 'network': network}
    f.write(json.dumps(data) + '\n')

sys.exit()
