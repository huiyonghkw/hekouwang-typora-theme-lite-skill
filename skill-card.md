## Description:

Maintains the hekouwang free V2 light and dark Typora themes (Lite skill:
`hekouwang-typora-theme-lite-skill`) and guides agents through token-driven CSS
generation, sampled color matching, font fallback verification, installation,
troubleshooting, and Typora theme publishing. Paid six-theme craft lives in
local `edition/` and ships as the Pro zip.

Lite skill text and free themes/scripts are MIT (root `LICENSE`). Paid pack
uses `LICENSE-PRO.txt`.

## Publisher:

[huiyonghkw](https://clawhub.ai/user/huiyonghkw)

### License/Terms of Use:

MIT (root `LICENSE` / `LICENSE.txt`). Copies previously published to ClawHub
under MIT-0 remain MIT-0. Paid theme pack is Proprietary (`LICENSE-PRO.txt`).

## Use Case:

Developers and designers use this skill to maintain or adapt Typora themes, especially Chinese long-form light and dark themes, by editing token sources, generating CSS, validating fonts and colors, installing locally, and preparing theme.typora.io submissions.

### Deployment Geography for Use:

Global

## Known Risks and Mitigations:

Risk: Local installation or publishing commands may run external repository scripts or GitHub CLI operations.

Mitigation: Review install.sh and any GitHub CLI commands before execution, and run them only in a trusted local workspace.

Risk: Theme edits can silently appear ineffective in Typora because modified CSS and fonts may not reload or may fall back without errors. Editing the wrong source file (colours in tokens.json, which the palette overrides) is also silently ineffective.

Mitigation: Follow the documented build, install, full Typora restart, color verification, and font fallback probe steps before treating changes as complete. Edit colours in scripts/palettes.json and reading metrics in tokens.json (_presets.work); the build refuses a tokens.json that reintroduces overridable sections, and references/tokens.md carries a which-file-to-edit table.

## Reference(s):

- [Skill definition](artifact/SKILL.md)
- [tokens.json adjustment guide](artifact/references/tokens.md)
- [Typora theme specification and selector map](artifact/references/typora-spec.md)
- [Font strategy and licensing boundaries](artifact/references/fonts.md)
- [Theme workflow](artifact/references/workflow.md)
- [Project homepage](https://github.com/huiyonghkw/hekouwang-typora-theme-skill)
- [Typora custom theme documentation](https://theme.typora.io/doc/Write-Custom-Theme/)

## Skill Output:

**Output Type(s):** [Guidance, Markdown, Code, Shell commands, Configuration]

**Output Format:** [Markdown guidance with inline shell commands, CSS/token editing instructions, and publishing steps]

**Output Parameters:** [1D]

**Other Properties Related to Output:** [Produces agent guidance for local theme files and Typora workflows; does not produce autonomous network actions.]

## Skill Version(s):

2.0.2 (source: frontmatter)

## Ethical Considerations:

Users should evaluate whether this skill is appropriate for their environment, review any generated or modified files before relying on them, and apply their organization's safety, security, and compliance requirements before deployment.
