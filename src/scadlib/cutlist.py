#!/usr/bin/env python

import argparse
import csv
import json
import math
import subprocess  # nosec B404
import tempfile
from collections import defaultdict
from fractions import Fraction
from itertools import groupby
from operator import itemgetter
from pathlib import Path
from typing import Any, Dict, Generator, Iterable, List, Optional, Union

from rich.console import Console
from rich.table import Table

console = Console()
DIM_PREFIX = 'ECHO: "dimensions: '
HEADER_PREFIX = 'ECHO: "dim_header: '
EXPORT_DELIMITERS: Dict[Optional[str], str] = {".csv": ",", ".tsv": "\t"}


def user_input() -> str:
    return console.input(prompt="[bold blue]>>>[/bold blue] ")


def info(*message: str) -> None:
    return console.print("[bold white]INFO:[/bold white] ", *message)


def error(*message: str) -> None:
    return console.print("[bold red]ERROR:[/bold red] ", *message)


def warn(*message: str) -> None:
    return console.print("[bold orange]WARN:[/bold orange] ", *message)


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
        error("Failed to parse line:\n", line)

    return None


def get_dimensions(file_path: Path) -> List[Dict[str, Any]]:
    # Create a temporary file for the export path
    with tempfile.NamedTemporaryFile(suffix=".stl") as temp_file:
        export_path = Path(temp_file.name)

        # Construct the command
        command = ["openscad", str(file_path), "-o", str(export_path)]

        # Run the command and capture the output
        process = subprocess.Popen(  # nosec B603
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
        error("Failed to find dimension header")
        exit(1)

    # Convert to a list of dictionaries
    dimensions = [dict(zip(field_names, row)) for row in rows]

    return dimensions


def consolidate_dimensions(
    dimensions: List[Dict[str, Any]]
) -> Generator[Dict[str, Any], None, None]:
    # Normalize the 'lx', 'ly', 'lz'
    for row in dimensions:
        row_dims = sorted([row["lx"], row["ly"], row["lz"]])
        row["lz"], row["lx"], row["ly"] = row_dims

    # Sort the dimensions based on the grouping keys
    dimensions.sort(key=itemgetter("material", "lx", "ly", "lz"))

    for _, group in groupby(dimensions, key=itemgetter("material", "lx", "ly", "lz")):
        group = list(group)
        first_row = group[0]

        # Initialize the aggregated row
        aggregated_row = {
            "material": first_row["material"],
            "thickness": first_row["lz"],
            "width": first_row["lx"],
            "length": first_row["ly"],
            "count": 0,
            "part_counts": defaultdict(int),
        }

        # Aggregate the 'count' and 'part_counts'
        for row in group:
            aggregated_row["count"] += row["count"]
            part_key = f"{row['part']}-{row['subpart']}"
            aggregated_row["part_counts"][part_key] += row["count"]

        yield aggregated_row


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


def get_table(dimensions: Iterable[Dict[str, Any]], metric: bool = False) -> Table:
    unit = "mm" if metric else "in"
    table = Table(title="Cut List", show_lines=True)
    table.add_column("Num", style="white")
    table.add_column("Material", style="cyan")

    table.add_column(f"Thickness ({unit})", style="magenta")
    table.add_column(f"Width ({unit})", style="green")
    table.add_column(f"Length ({unit})", style="yellow")
    table.add_column("Count", style="red")
    table.add_column("Parts", style="pink1")

    for idx, row in enumerate(dimensions):
        table.add_row(
            str(idx + 1),
            row["material"],
            str(row["thickness"]),
            str(row["width"]),
            str(row["length"]),
            str(row["count"]),
            row["parts"],
        )
    return table


def export(
    dimensions: Iterable[Dict[str, Any]], path: Path, header: Optional[List[str]] = None
) -> None:
    rows = list(dimensions)
    if not rows:
        error("No rows to export")
        exit(1)

    file_extension = path.suffix.lower() if path.suffix else None
    delimiter = EXPORT_DELIMITERS.get(file_extension)

    if not delimiter:
        error(
            "Cannot detect export format.",
            "Unknown file extension: ",
            str(file_extension),
        )
        exit(1)

    if not header:
        header = list(rows[0].keys())

    # Ensure every row has all keys from header, fill in missing keys with ''
    cleaned_rows = [{**dict.fromkeys(header, ""), **row} for row in rows]

    with open(path, "w", newline="", encoding="utf-8") as file:
        writer = csv.DictWriter(file, fieldnames=header, delimiter=delimiter)
        writer.writeheader()
        writer.writerows(cleaned_rows)
    info("Export complete: ", str(path))


def format_output(
    dimensions: Iterable[Dict[str, Any]],
    fraction: bool = False,
    metric: bool = False,
    stock: Optional[str] = None,
    max_dimension: float = float("inf"),
) -> Generator[Dict[str, Any], None, None]:
    for row in sorted(
        dimensions,
        key=lambda x: (x["material"], x["thickness"], x["width"], x["length"]),
    ):
        # skip nonmatching material, if specified
        if stock and row["material"] != stock:
            continue

        count_modifier = 1
        dims = {}
        for key in ["thickness", "width", "length"]:
            val = row[key]

            if val > max_dimension:
                split_count = math.ceil(val / max_dimension)
                val = val / split_count
                count_modifier *= split_count

            dims[key] = format_num(val, fraction=fraction, metric=metric)

        part_counts = "\n".join(
            [
                f"{key}:{count * count_modifier}"
                for key, count in row["part_counts"].items()
            ]
        )

        yield {
            "material": row["material"],
            "count": row["count"] * count_modifier,
            "parts": part_counts,
            **dims,
        }


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
    formatted = format_output(
        consolidated,
        fraction=args.fraction,
        metric=args.metric,
        stock=args.stock,
        max_dimension=args.max_dimension,
    )

    if args.export:
        export_path = Path(args.export)
        return export(formatted, export_path, header=args.export_header)

    table = get_table(formatted)
    console.print(table)


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
    parser.add_argument(
        "-eh",
        "--export-header",
        nargs="+",
        type=str,
        help="Optional header ordering for export file.",
    )

    # TODO support a distinct max dimension on 2 planes.
    # as-is, if you can only access assymetric stock (4x8),
    # you can have impossible values like 6x6
    # TODO support a distrinct max for different materials.
    parser.add_argument(
        "--max-dimension",
        default=float("inf"),
        type=float,
        help="If provided, any dimension over this limit will be subdivided",
    )

    args = parser.parse_args()
    main(args)
