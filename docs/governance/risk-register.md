# Risk Register

| ID    | Risk                                                                    | Probability | Impact | Response                                             | Owner    | Status |
| ----- | ----------------------------------------------------------------------- | ----------- | ------ | ---------------------------------------------------- | -------- | ------ |
| R-001 | Single-account implementation diverges from target multi-account design | Medium      | High   | Document target state and constrain shared resources | Fernando | Open   |
| R-002 | Missing or inconsistent tags reduce cost visibility                     | High        | Medium | Enforce mandatory tags in Terraform modules          | Fernando | Open   |
| R-003 | Sandbox-style experimentation bleeds into governed environments         | Medium      | High   | Define account boundaries and future OU isolation    | Fernando | Open   |
| R-004 | Evidence discipline weakens over time                                   | Medium      | High   | Make evidence mandatory at every phase gate          | Fernando | Open   |
| R-005 | Budget alerts are defined but not operationalized later                 | Medium      | Medium | Add AWS Budgets implementation in a later phase      | Fernando | Open   |
| R-006 | Naming drift causes audit and troubleshooting confusion                 | Medium      | Medium | Standardize naming and reference it in reviews       | Fernando | Open   |
