
### **Comparison Table**

| Feature                  | Replication Controller                      | Replica Set                                      |
|--------------------------|---------------------------------------------|--------------------------------------------------|
| **Selector Type**        | Equality-Based Selectors                    | Set-Based Selectors                              |
| **Management Style**     | Imperative                                  | Declarative                                      |
| **Pod Selection**        | Matches exact key-value pairs               | Supports operators like `In`, `NotIn`, `Exists`  |
| **Usage**                | Basic replication needs                     | Advanced replication and used by Deployments     |
| **Rolling Updates**      | Not inherently supported                    | Supported via Deployments                        |

---------
1. **What are the main differences between a Replication Controller and a Replica Set?**
   - The main differences are in the selector types and management styles. Replication Controllers use equality-based selectors and are more imperative, while Replica Sets use set-based selectors and are more declarative.

1. **Why are Replica Sets preferred over Replication Controllers?**
   - Replica Sets are preferred because they support set-based selectors, which provide more flexibility in pod selection.
   - `Support Rolling Updates`

2. **How do Deployments utilize Replica Sets?**
   - Deployments manage Replica Sets.
   - Deployments handle rolling updates and rollbacks
