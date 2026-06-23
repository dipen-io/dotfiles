#!/usr/bin/env python3
"""
Git History Learning Tool - Step-by-Step Code Evolution
Creates ordered snapshots so you can learn code chronologically.
"""

import subprocess
from pathlib import Path

# Get all commits in chronological order (oldest first)
commits = subprocess.check_output(
    ["git", "rev-list", "--reverse", "HEAD"],
    text=True
).splitlines()

total = len(commits)
print(f"Total commits: {total}")

outdir = Path(".snapshots")
outdir.mkdir(exist_ok=True)

for step, commit in enumerate(commits, start=1):
    # Name folder with step number + short hash for easy ordering
    # Format: 001_xxxxxxx, 002_xxxxxxx, etc.
    folder_name = f"{step:03d}_{commit[:7]}"
    folder = outdir / folder_name
    folder.mkdir(exist_ok=True)

    # Get commit info for a README inside each folder
    subject = subprocess.check_output(
        ["git", "log", "-1", "--format=%s", commit],
        text=True
    ).strip()

    date = subprocess.check_output(
        ["git", "log", "-1", "--format=%ad", "--date=short", commit],
        text=True
    ).strip()

    # Extract the snapshot
    archive = subprocess.Popen(
        ["git", "archive", commit],
        stdout=subprocess.PIPE
    )

    subprocess.run(
        ["tar", "-x", "-C", str(folder)],
        stdin=archive.stdout
    )

    # Create a README.txt inside each snapshot so you know what this step is
    readme = folder / "README.txt"
    readme.write_text(f"""STEP {step} of {total}
==================
Commit: {commit}
Date:   {date}
Message: {subject}

This is {'the FIRST commit' if step == 1 else 'the LATEST commit' if step == total else f'commit {step} in the history'}.

To study:
- Previous step: ../{f"{(step-1):03d}_{commits[step-2][:7]}" if step > 1 else "(none - this is the first)"}
- Next step:     ../{f"{(step+1):03d}_{commits[step][:7]}" if step < total else "(none - this is the latest)"}
""")

    print(f"[{step:03d}/{total}] Created {folder_name} - {subject[:50]}")

# Create a master README in the snapshots folder
master_readme = outdir / "README.txt"
master_readme.write_text(f"""GIT HISTORY SNAPSHOTS
=====================

Total commits: {total}

HOW TO STUDY:
1. Start with folder 001_xxxxxxx (the very first code written)
2. Then go to 002_xxxxxxx (the next change)
3. Continue in number order: 003, 004, 005...
4. The last folder ({total:03d}_xxxxxxx) is the latest code

FOLDER NAMING:
- 001_xxxxxxx = Step 1 (oldest, first commit ever)
- 002_xxxxxxx = Step 2
- ...
- {total:03d}_xxxxxxx = Step {total} (newest, latest code)

Each folder contains:
- The full codebase at that point in time
- README.txt explaining what changed in that step
""")

print(f"\n✅ Done! {total} snapshots created in ./{outdir}/")
print(f"📖 Read {outdir}/README.txt for study instructions")
print(f"\nStart here: {outdir}/001_{commits[0][:7]}/")


