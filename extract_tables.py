import csv
import glob
import os
from bs4 import BeautifulSoup

# Map source header names to canonical output column names
HEADER_MAP = {
    "type": "Type",
    "postcode": "PostCode",
    "oldborough": "Borough",
    "borough": "Borough",
    "area": "Area",
    "positioning": "Positioning",
    "position": "Positioning",
    "date": "Date",
    "time": "Time",
    "publish_text": "Description",
    "notes": "Description",
    "note": "Description",
    "deaths": "Deaths",
}

CANONICAL = ["Type", "PostCode", "Borough", "Area", "Positioning", "Date", "Time", "Description", "Deaths"]


def cell_text(td):
    return " ".join(td.get_text(separator=" ").split())


def extract_data_table(soup):
    """Find the main data table (the one with recognised headers)."""
    for table in soup.find_all("table"):
        # Collect header cells from <th> or from the first <tr> in <thead>
        header_cells = table.find_all("th")
        if not header_cells:
            thead = table.find("thead")
            if thead:
                # Find the header row — may be preceded by a title row (colspan)
                for tr in thead.find_all("tr"):
                    candidate = tr.find_all("td")
                    texts = [cell_text(c).lower() for c in candidate]
                    if any(t in HEADER_MAP for t in texts):
                        header_cells = candidate
                        break

        if not header_cells:
            continue

        headers = [cell_text(h).lower() for h in header_cells]
        if not any(h in HEADER_MAP for h in headers):
            continue

        # Build index mapping: canonical name → column index in this table
        col_index = {}
        for i, h in enumerate(headers):
            canon = HEADER_MAP.get(h)
            if canon:
                col_index[canon] = i

        missing = [c for c in CANONICAL if c not in col_index]
        if missing:
            print(f"  WARNING: missing columns {missing} (headers found: {headers})")

        # Collect data rows — skip header rows
        rows = []
        for tr in table.find_all("tr"):
            cells = tr.find_all("td")
            # Skip header rows (cells with <b> styling only / no real data)
            if len(cells) != len(headers):
                continue
            # Skip if this looks like a header row repeated
            first = cell_text(cells[0]).lower()
            if first in HEADER_MAP:
                continue

            row = [cell_text(cells[col_index[c]]) if c in col_index else "" for c in CANONICAL]
            if any(row):
                rows.append(row)

        return rows

    return []


raw_dir = os.path.join(os.path.dirname(__file__), "raw")
output_path = os.path.join(os.path.dirname(__file__), "data", "incidents.csv")
os.makedirs(os.path.dirname(output_path), exist_ok=True)

all_rows = []
for html_file in sorted(glob.glob(os.path.join(raw_dir, "*.html"))):
    with open(html_file, "r", encoding="windows-1252", errors="replace") as f:
        content = f.read()
    soup = BeautifulSoup(content, "html.parser")
    rows = extract_data_table(soup)
    if not rows:
        print(f"WARNING: no data extracted from {os.path.basename(html_file)}")
    else:
        print(f"{os.path.basename(html_file)}: {len(rows)} rows")
    all_rows.extend(rows)

with open(output_path, "w", newline="", encoding="utf-8") as f:
    writer = csv.writer(f)
    writer.writerow(CANONICAL)
    writer.writerows(all_rows)

print(f"\nTotal: {len(all_rows)} rows → {output_path}")
