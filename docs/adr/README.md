# Architecture Decision Records (ADRs)

This directory contains Architecture Decision Records for the **redwing** project. ADRs document important architectural
and design decisions, helping the team understand why certain choices were made and what alternatives were considered.

## Current ADRs

| Number                                                        | Title                                  | Status   | Date       |
|---------------------------------------------------------------|----------------------------------------|----------|------------|
| [ADR-0001](0001-core-dependencies.md)                         | Core Dependencies                      | Accepted | 2026-04-07 |
| [ADR-0002](0002-test-tooling.md)                              | Test Tooling                           | Accepted | 2026-04-07 |
| [ADR-0003](0003-template-variable-binding.md)                 | Template Variable Binding              | Accepted | 2026-04-08 |
| [ADR-0004](0004-api-routing-and-project-bootstrap.md)         | API Routing and Project Bootstrap      | Accepted | 2026-04-08 |
| [ADR-0005](0005-erb-rendering-and-layout.md)                  | ERB Rendering and Layout System        | Accepted | 2026-04-08 |
| [ADR-0006](0006-configuration-and-logging.md)                 | Configuration and Logging              | Accepted | 2026-04-08 |
| [ADR-0007](0007-route-context.md)                             | RouteContext as instance_eval Target   | Accepted | 2026-04-11 |

## Creating a New ADR

1. **Copy the template**: Use `template.md` as your starting point
2. **Number sequentially**: Use the next available number (e.g., 0002, 0003, etc.)
3. **Follow the format**: Fill in all required sections
4. **Submit for review**: Create a PR for team discussion
5. **Update this README**: Add your ADR to the table above

## ADR Lifecycle

### Status Values

- **Proposed**: Under discussion, not yet decided
- **Accepted**: Approved and currently active
- **Deprecated**: No longer recommended but may still be in use
- **Superseded**: Replaced by a newer ADR

### When to Create an ADR

Create an ADR for decisions that:

- Affect the overall architecture or design patterns
- Have significant long-term impact
- Involve trade-offs between multiple viable options
- Need to be communicated across the team
- Future team members should understand

### Examples of ADR-worthy decisions:

- Technology choices (frameworks, libraries, tools)
- Architectural patterns and structures
- API design approaches
- Data storage strategies
- Integration patterns
- Development workflow changes

## Best Practices

### Writing ADRs

- **Be concise**: Keep it readable in 5-10 minutes
- **Focus on "why"**: Explain reasoning, not just what was decided
- **Include context**: Help readers understand the situation
- **List alternatives**: Show what options were considered
- **Be honest about trade-offs**: Include both positive and negative consequences

### Maintaining ADRs

- **Update status**: Change status as decisions evolve
- **Link related ADRs**: Reference other relevant decisions
- **Don't delete**: Deprecated ADRs provide valuable historical context
- **Keep them current**: Update if implementation details change significantly

## Resources

- [ADR GitHub Organization](https://adr.github.io/) - Community resources and examples
- [Architecture Decision Records by Michael Nygard](http://thinkrelevance.com/blog/2011/11/15/documenting-architecture-decisions) -
  Original blog post
- [ADR Tools](https://github.com/npryce/adr-tools) - Command-line tools for managing ADRs

## Questions?

If you have questions about the ADR process or need help creating an ADR, reach out to the team or reference existing
ADRs as examples.