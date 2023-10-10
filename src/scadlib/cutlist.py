#!/usr/bin/env python

import argparse
import subprocess
import tempfile
import json
from fractions import Fraction
from collections import defaultdict
from itertools import groupby
from operator import itemgetter
from typing import Optional, List, Any, Dict, Iterable, Union
from pathlib import Path
from rich.console import Console
from rich.table import Table

console = Console()
DIM_PREFIX = 'ECHO: "dimensions: '
HEADER_PREFIX = 'ECHO: "dim_header: '


def mm_to_inches(mm: float) -> float:
    """Converts millimeters to inches."""
    return mm / 25.4


def inches_to_mm(inches: float) -> float:
    """Converts inches to millimeters."""
    return inches * 25.4


def done(msg: Optional[str] = None) -> None:
    if msg:
        console.print(msg)
    console.print("Quitting...")
    quit(0)


def parse_openscad_line(line: str) -> Optional[List[str]]:
    clean_line = None
    for prefix in (DIM_PREFIX, HEADER_PREFIX):
        if line.startswith(prefix):
            clean_line = line[len(prefix) : -1]

    if not clean_line:
        return None

    try:
        return json.loads(clean_line)
    except json.JSONDecodeError:
        console.print("[bold red]ERROR:[/bold red] Failed to parse line:\n", clean_line)

    return None


def get_dimensions(file_path: Path) -> List[Dict[str, Any]]:
    # Create a temporary file for the export path
    with tempfile.NamedTemporaryFile(suffix=".stl") as temp_file:
        export_path = Path(temp_file.name)

        # Construct the command
        command = ["openscad", str(file_path), "-o", str(export_path)]

        # Run the command and capture the output
        process = subprocess.Popen(
            command, stdout=subprocess.PIPE, stderr=subprocess.PIPE
        )
        _, stderr = process.communicate()

        if process.returncode != 0:
            raise RuntimeError(
                f"openscad failed with error code {process.returncode}.\n{stderr.decode('utf-8')}"
            )

    # Filter the output lines
    field_names = None
    output_lines = stderr.decode("utf-8").splitlines()
    rows = []
    for line in output_lines:
        parsed_line = parse_openscad_line(line)
        if parsed_line is None:
            continue

        if line.startswith(HEADER_PREFIX):
            field_names = parsed_line
            continue

        rows.append(parsed_line)

    if field_names is None:
        console.print("[bold red]ERROR:[/bold red] Failed to find dimension header")
        exit(1)

    # Convert to a list of dictionaries
    dimensions = [dict(zip(field_names, row)) for row in rows]

    return dimensions


def consolidate_dimensions(dimensions: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
    # Normalize the 'lx', 'ly', 'lz'
    for row in dimensions:
        row_dims = sorted([row["lx"], row["ly"], row["lz"]])
        row["lz"], row["lx"], row["ly"] = row_dims

    # Sort the dimensions based on the grouping keys
    dimensions.sort(key=itemgetter("material", "lx", "ly", "lz"))

    grouped_dimensions = []
    for _, group in groupby(dimensions, key=itemgetter("material", "lx", "ly", "lz")):
        group = list(group)
        first_row = group[0]

        # Initialize the aggregated row
        aggregated_row = {
            "material": first_row["material"],
            "lx": first_row["lx"],
            "ly": first_row["ly"],
            "lz": first_row["lz"],
            "count": 0,
            "part_counts": defaultdict(int),
        }

        # Aggregate the 'count' and 'part_counts'
        for row in group:
            aggregated_row["count"] += row["count"]
            part_key = f"{row['part']}-{row['subpart']}"
            aggregated_row["part_counts"][part_key] += row["count"]

        grouped_dimensions.append(aggregated_row)

    return grouped_dimensions


def format_num(
    number: Union[float, int], fraction: bool = True, metric: bool = False
) -> str:
    if not metric:
        number = mm_to_inches(number)
    if fraction:
        return fractionalize(number)
    return f"{number:.4f}"


def fractionalize(number: float) -> str:
    whole_part = int(number)
    fractional_part = number - whole_part

    # Create a Fraction object for the fractional part and limit the denominator
    fraction = Fraction(fractional_part).limit_denominator()

    # Construct the string representation
    if whole_part and fraction:  # both whole and fractional parts are present
        result = f"{whole_part} {fraction}"
    elif whole_part:  # only the whole part is present
        result = str(whole_part)
    elif fraction:  # only the fractional part is present
        result = str(fraction)
    else:  # the number is zero
        result = "0"

    return result


def get_table(
    dimensions: Iterable[Dict[str, Any]], fraction: bool = False, metric: bool = False
) -> Table:
    unit = "mm" if metric else "in"
    table = Table(title="Cut List", show_lines=True)
    table.add_column("Num", style="white")
    table.add_column("Material", style="cyan")

    table.add_column(f"X ({unit})", style="magenta")
    table.add_column(f"Y ({unit})", style="green")
    table.add_column(f"Z ({unit})", style="yellow")
    table.add_column("Count", style="red")
    table.add_column("Parts", style="pink1")

    for idx, row in enumerate(
        sorted(dimensions, key=lambda x: (x["material"], x["lz"], x["lx"], x["ly"]))
    ):
        part_counts = "\n".join(
            [f"{key}:{count}" for key, count in row["part_counts"].items()]
        )

        dims = (row["lz"], row["lx"], row["ly"])
        dims = tuple(format_num(dim, fraction=fraction, metric=metric) for dim in dims)

        table.add_row(
            str(idx + 1),
            row["material"],
            *dims,
            str(row["count"]),
            part_counts,
        )
    return table

def format_output(
    dimensions: Iterable[Dict[str, Any]], fraction: bool = False, metric: bool = False
) -> Table:
    unit = "mm" if metric else "in"
    # table = Table(title="Cut List", show_lines=True)
    # table.add_column("Num", style="white")
    # table.add_column("Material", style="cyan")

    # table.add_column(f"X ({unit})", style="magenta")
    # table.add_column(f"Y ({unit})", style="green")
    # table.add_column(f"Z ({unit})", style="yellow")
    # table.add_column("Count", style="red")
    # table.add_column("Parts", style="pink1")

    for idx, row in enumerate(
        sorted(dimensions, key=lambda x: (x["material"], x["lz"], x["lx"], x["ly"]))
    ):
        part_counts = "\n".join(
            [f"{key}:{count}" for key, count in row["part_counts"].items()]
        )

        dims = (row["lz"], row["lx"], row["ly"])
        dims = tuple(format_num(dim, fraction=fraction, metric=metric) for dim in dims)

        table.add_row(
            str(idx + 1),
            row["material"],
            *dims,
            str(row["count"]),
            part_counts,
        )
    return table


def main(args: argparse.Namespace) -> None:
    file = args.scadfile
    if not file:
        done("No file specified.")

    file_path = Path(file)
    if not file_path.exists():
        raise FileNotFoundError(f"{file_path} does not exist.")

    console.print(f"Processing file: {file_path}")
    dimensions = get_dimensions(file_path)
    consolidated = consolidate_dimensions(dimensions)

    if args.stock:
        consolidated = filter(lambda row: row["material"] == args.stock, consolidated)

    table = get_table(consolidated, fraction=args.fraction, metric=args.metric)
    console.print(table)

    if args.export:
        


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        prog="Generate a cutlist for openscad files",
        description="generate a minimal set of cutting dimensions based on terminal output from an openscad file",
    )

    parser.add_argument(
        "scadfile", type=str, help="The source openscad file for dimensions"
    )

    parser.add_argument(
        "-s", "--stock", type=str, help="Filter based on stock material being used."
    )

    parser.add_argument(
        "-m",
        "--metric",
        default=False,
        help="If true, will output data in millimeters",
        action="store_true",
    )
    parser.add_argument(
        "-f",
        "--fraction",
        default=False,
        help="If true, will output data as a fraction",
        action="store_true",
    )

    parser.add_argument(
        "-e", "--export", type=str, help="Optional export file. Supports tsv and csv."
    )

    args = parser.parse_args()
    main(args)
