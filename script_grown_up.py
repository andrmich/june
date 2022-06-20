import pathlib
import re

INPUT_FILE = pathlib.Path(__file__).parent.absolute() / "clickhouse-server-logs.txt"

YELLOW = "\033[33m{}\033[0m"
BLUE = "\033[34m{}\033[0m"

REPLACEMENTS = [
    ("PostgreSQLReaplicaConsumer", YELLOW.format("RC")),
    ("PostgreSQLConnection", BLUE.format("CO")),
    ("New connection", "NEW CONNECTION"),
]

if __name__ == '__main__':
    with INPUT_FILE.open() as f:
        input_lines = f.readlines()

    print("Only unique Debug level logs for PostgreSQL")
    for line in input_lines:
        if "PostgreSQL" not in line or "<Debug>" not in line:
            continue
        line = line.rstrip()
        line = re.sub(r"^clickhouse-server\.log\.\d+\.gz:\d+[:-]", "", line)
        lp = line.split()
        line = f"{lp[0]} {lp[1]}: {' '.join(lp[7:])}"
        for current, new in REPLACEMENTS:
            line = line.replace(current, new)
        print(line)

