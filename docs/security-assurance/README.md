# Rendering the security assurance report

[SECURITY-ASSURANCE.md](../SECURITY-ASSURANCE.md) is the source of truth. The
[PDF](../SECURITY-ASSURANCE.pdf) is its printable companion. Edit the Markdown and
regenerate the PDF together; do not edit the PDF or keep a second diagram source.
The renderer extracts the Mermaid fence and renders that exact source to a high-resolution PNG
before converting the Markdown with Pandoc and WeasyPrint. Reference links stay
clickable; relative document links are expanded to their GitHub main URLs in the
PDF so they do not point into a temporary rendering directory. No product build or remote publication is part of this process.

Validated sandbox tool versions: Pandoc 2.17.1.1, WeasyPrint 57.2 and Mermaid CLI
12.2.0, with system Chromium. These are documentation-rendering tools, not product
runtime dependencies. Install Pandoc, WeasyPrint, Chromium and suitable DejaVu
fonts with your sandbox's package manager. A temporary Mermaid CLI installation
can use system Chromium without downloading another browser:

```sh
PUPPETEER_SKIP_DOWNLOAD=true npm install --prefix /tmp/security-render-tools \
  @mermaid-js/mermaid-cli@12.2.0 --no-audit --no-fund
PATH="/tmp/security-render-tools/node_modules/.bin:$PATH" \
  python3 docs/security-assurance/render.py --chromium /usr/bin/chromium
pdfinfo docs/SECURITY-ASSURANCE.pdf
pdftotext -layout docs/SECURITY-ASSURANCE.pdf /tmp/security-assurance.txt
```

Inspect the rendered pages, especially the diagram, long commands and tables;
check all fifteen sections and the evidence index survive extraction. Renderer
metadata can vary with tool versions/time; do not claim byte-reproducible PDF
output. This report's product reproducibility claims refer only to named build
records. Keep live API verification observations dated in the evidence JSON,
preserve failed outcomes, and update affected requirement trace links together.
