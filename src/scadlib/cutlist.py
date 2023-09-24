#!/usr/bin/env python

import argparse
import subprocess
import tempfile
import json
from collections import defaultdict
from itertools import groupby
from operator import itemgetter
from typing import Optional, List, Any, Dict
from pathlib import Path
from rich.console import Console
from rich.table import Table

console = Console()
FILTER_PREFIX = 'ECHO: "dimensions: '


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
    output_lines = stderr.decode("utf-8").splitlines()
    processed_lines = []
    for line in output_lines:
        if not line.startswith(FILTER_PREFIX):
            continue
        clean_line = line[len('ECHO: "dimensions: ') : -1]
        parsed_line = json.loads(clean_line)
        processed_lines.append(parsed_line)

    # The first line is the field names, and the others are the rows
    field_names, *rows = processed_lines

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


def get_table(dimensions: List[Dict[str, Any]], metric: bool = False) -> Table:
    unit = "mm" if metric else "in"
    table = Table(title="Cut List", show_lines=True)
    table.add_column("Material", style="cyan")

    table.add_column(f"X ({unit})", style="magenta")
    table.add_column(f"Y ({unit})", style="green")
    table.add_column(f"Z ({unit})", style="yellow")
    table.add_column("Count", style="red")
    table.add_column("Parts", style="pink1")

    for row in sorted(
        dimensions, key=lambda x: (x["material"], x["lz"], x["lx"], x["ly"])
    ):
        part_counts = "\n".join(
            [f"{key}:{count}" for key, count in row["part_counts"].items()]
        )

        dims = (row["lz"], row["lx"], row["ly"])
        if not metric:
            dims = tuple(mm_to_inches(dim) for dim in dims)

        table.add_row(
            row["material"],
            f"{dims[0]:.4f}",
            f"{dims[1]:.4f}",
            f"{dims[2]:.4f}",
            str(row["count"]),
            part_counts,
        )
    return table


def main(args: argparse.Namespace) -> None:
    if not args.file:
        done("No file specified.")

    file_path = Path(args.file)
    if not file_path.exists():
        raise FileNotFoundError(f"{file_path} does not exist.")

    console.print(f"Processing file: {file_path}")
    dimensions = get_dimensions(file_path)
    consolidated = consolidate_dimensions(dimensions)
    table = get_table(consolidated)
    console.print(table)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        prog="Generate a cutlist for openscad files",
        description="generate a minimal set of cutting dimensions based on terminal output from an openscad file",
    )

    parser.add_argument(
        "-f", "--file", type=str, help="The source openscad file for dimensions"
    )

    parser.add_argument(
        "-m",
        "--metric",
        default=False,
        help="If true, will output data in millimeters",
        action="store_true",
    )

    args = parser.parse_args()
    main(args)
