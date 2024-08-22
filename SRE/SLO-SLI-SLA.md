### Service Level Indicators (SLIs), Service Level Objectives (SLOs), and Service Level Agreements (SLAs)

#### 1. **Service Level Indicators (SLIs)**

- **Concept:**
  - SLIs are metrics that quantify the performance of a service 
  - They are the building blocks for SLOs.

- **Common SLIs:**
  - **Availability:** 
  - **Latency:** 
  - **Error Rate:** Percentage of requests that result in errors.

- **Study Areas:**
  - **How to Define SLIs:**
    - Understand what aspects of service are most critical to the user experience.
    - Choose metrics that accurately reflect these critical aspects.
    - Ensure SLIs are measurable, relevant, and aligned with business objectives.

#### 2. **Service Level Objectives (SLOs)**

- **Concept:**
  - SLOs are the targets or goals set for the SLIs. They define the acceptable level of performance for a service over a specific period.
  - SLOs are typically expressed as a percentage or percentile (e.g., "99.9% availability over the past 30 days").

- **Importance of SLOs:**
  - **Guiding Operations:** reliability efforts by setting clear targets for the operations team.
  - **Balancing Reliability and Innovation:** By defining clear goals, SLOs allow for error budgeting, helping to balance the need for service reliability with the pace of development and innovation.
  - **Stakeholder Communication:** SLOs provide a clear, quantifiable way to communicate reliability goals to stakeholders.

- **Study Areas:**
  - **Setting SLOs:**
    - Consider customer expectations and business needs when setting SLOs.
    - Use historical data and industry standards to set realistic and achievable SLOs.
    - Understand the impact of different SLO levels on the error budget.

#### 3. **Service Level Agreements (SLAs)**

- **Concept:**
  - SLAs are formal agreements between a service provider and a customer, often legally binding, that define the expected level of service, penalties for failing to meet these levels, and remedies for the customer.

- **Study Areas:**
  - **Defining SLAs:**
    - Ensure SLAs are realistic, achievable, and reflect the agreed-upon SLOs.
    - Include clear terms for monitoring, reporting, and addressing SLA violations.
  - **Negotiating SLAs:**
    - Balance the need to meet customer expectations with the technical realities and risks involved.
    - Consider how SLA terms might influence the design and operation of services.

### Techniques for Monitoring and Measuring SLIs

- **Monitoring Tools:**
  - Use tools like Prometheus, Grafana, or Datadog to collect, visualize, and analyze SLI data.

- **Data Collection:**
  - Instrument your services to collect relevant SLI data. 

- **SLI Calculation:**
  - Use statistical methods to calculate percentiles, averages, or ratios that represent the SLIs.


