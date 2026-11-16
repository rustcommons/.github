#!/usr/bin/env python3
"""Render SECURITY-ASSURANCE.md; Mermaid fences remain the diagram authority."""
import argparse
from pathlib import Path
import json
import re
import subprocess
import tempfile
from urllib.parse import urljoin, urlsplit


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--chromium', default='/usr/bin/chromium')
    args = parser.parse_args()
    here = Path(__file__).resolve().parent
    docs = here.parent
    source = (docs / 'SECURITY-ASSURANCE.md').read_text(encoding='utf-8')
    with tempfile.TemporaryDirectory(prefix='rustcommons-assurance-') as tmp:
        work = Path(tmp)
        config = work / 'puppeteer.json'
        config.write_text(json.dumps({'executablePath': args.chromium,
                                     'args': ['--no-sandbox', '--disable-dev-shm-usage']}))
        mermaid_config = work / 'mermaid.json'
        mermaid_config.write_text(json.dumps({'htmlLabels': False,
                                             'flowchart': {'htmlLabels': False},
                                             'fontFamily': 'DejaVu Sans'}))
        count = 0

        def diagram(match):
            nonlocal count
            count += 1
            mermaid = work / f'architecture-{count}.mmd'
            image = mermaid.with_suffix('.png')
            mermaid.write_text(match.group(1), encoding='utf-8')
            subprocess.run(['mmdc', '-i', str(mermaid), '-o', str(image), '-s', '2', '--size', '1400',
                            '-p', str(config), '-c', str(mermaid_config),
                            '-b', 'white', '-t', 'neutral'], check=True)
            return f'![Architecture and trust boundaries]({image.as_uri()})'

        rendered = re.sub(r'```mermaid\n(.*?)```', diagram, source, flags=re.S)
        if count != 1:
            raise ValueError('Expected one authoritative Mermaid architecture diagram')
        markdown = work / 'report.md'
        markdown.write_text(rendered, encoding='utf-8')
        html = work / 'report.html'
        subprocess.run(['pandoc', str(markdown), '--from=markdown', '--to=html5',
                        '--standalone', '--self-contained', '--resource-path', str(docs),
                        '--metadata', 'pagetitle=Rust Commons security assurance for disconnected networks',
                        '--css', str(here / 'print.css'), '--output', str(html)], check=True,
                       cwd=docs)
        # A downloaded PDF must not link to this renderer's temporary directory.
        def repository_link(match):
            target = match.group(1)
            if target.startswith('#') or urlsplit(target).scheme:
                return match.group(0)
            target = urljoin('https://github.com/rustcommons/.github/blob/main/docs/', target)
            return f'href="{target}"'

        html.write_text(re.sub(r'href="([^"]+)"', repository_link,
                               html.read_text(encoding='utf-8')), encoding='utf-8')
        subprocess.run(['weasyprint', str(html), str(docs / 'SECURITY-ASSURANCE.pdf')], check=True)


if __name__ == '__main__':
    main()
