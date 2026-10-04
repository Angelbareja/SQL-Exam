## 🚀 Key Features & Architectural Highlights
*   **Robust Data Integrity:** Implements rigorous entity-preservation strategies utilizing `PRIMARY KEY`, `FOREIGN KEY`, strict nullification methods (`ON DELETE SET NULL`), and cascade triggers (`ON DELETE CASCADE`) to eliminate orphaned records.
*   **Domain Validation Rules:** Leverages conditional `CHECK` constraints on operational infrastructure to restrict data entry to pre-approved clinical categories (e.g., specific room classifications).
*   **Performance Engineering:** Optimizes query performance by utilizing a **STORED virtual column** (`Total_Amount`) to pre-compute transactional sums, drastically reducing execution latency during high-frequency reporting cycles.
*   **Safe Transaction Management:** Written with transaction safety adjustments (`SQL_SAFE_UPDATES`) to simulate production-safe updates and bulk data migrations.
---## 📐 Entity-Relationship Architecture & Schema Design
The architecture follows strict normalization forms to minimize data redundancy and maximize write efficiency. The database consists of 5 core tables:
### 🏛️ Data Dictionary
1.  **`DOCTOR`**: Master ledger of clinical practitioners containing unique identification, specialization metrics, hire history, tenure tracking, and compensation values.
2.  **`PATIENT`**: Core clinical registry capturing demographic attributes, presenting diagnostics, and explicit foreign mapping to primary care providers.
3.  **`ROOM`**: Infrastructure inventory management tracking structural types (`ICU`, `General`, `Deluxe`, `Private`) alongside active operational statuses (`Available`, `Occupied`).
4.  **`ADMIT_PATIENT`**: Transactional registry tracking physical admission milestones, linking specific beds to active patients, and managing discharge boundaries.
5.  **`BILL`**: Financial transactional ledger aggregating distinct overhead categories (Doctor, Room, Medication charges) with automated server-side totalization.
### 🗺️ System Lineage Visual Diagram

┌──────────────┐ ┌──────────────┐
│ DOCTOR │ │ PATIENT │◄────────────┐
├──────────────┤ ├──────────────┤ │
│ Doctor_Id PK │◄───┐ │ Patient_Id PK│ │
└──────────────┘ │ └──────┬───────┘ │
│ │ ▲ │
│ │ │ │
│ ▼ │ │
┌──────────┴───┐ ┌───────────┴────┐ ┌──────┴──────┐
│ PATIENT │ │ ADMIT_PATIENT │ │ BILL │
├──────────────┤ ├────────────────┤ ├─────────────┤
│ Doctor_Id FK │ │ Patient_Id FK │ │Patient_Id FK│
└──────────────┘ └───────────┬────┘ └─────────────┘
│
▼
┌──────────────┐
│ ROOM │
├──────────────┤
│ Room_No FK │
└──────────────┘


---

## 💻 Enterprise Query Implementations & Analytics

The suite includes realistic healthcare administrative queries showcasing advanced capabilities:

### 🔍 Advanced Multi-Table Joins & Filtering
*   **Active Occupancy Trackers:** Uses multi-layered `INNER JOIN` conditions across `ROOM`, `ADMIT_PATIENT`, and `PATIENT` to provide clinical floors with real-time names of patients currently assigned to specific rooms where discharge records remain open (`NULL`).
*   **High-Value Accounts Receivable Audits:** Joins patient demographics with billing tables using mathematical filters (`> 50000`) to quickly expose high-balance accounts for administrative review.
*   **Clinical Staff Assignment Logs:** Implements an asymmetric `LEFT JOIN` mapping all patients to their responsible specialist, ensuring non-assigned or outpatient configurations remain visible in audit logs.

### 📊 Aggregations, Grouping & Optimization Metrics
*   **Provider Saturation Metrics:** Evaluates scheduling pipelines by grouping records across providers, compiling immediate patient density metrics, and sorting them (`ORDER BY DESC LIMIT 1`) to flag the highest-utilized medical officer.
*   **Infrastructure Availability Dashboards:** Groups spatial capacities by structural type to aggregate real-time resource availability summaries, filtering out occupied locations.
*   **Departmental Overhead Averages:** Applies `AVG()` mathematical operations on salary values grouped by specialization fields to provide high-level cost metrics for budgeting.

### 🛠️ Data Manipulation, Cascades & Safe Operations
*   **Tenure-Based Merit Adjustments:** Simulates corporate payroll updates by dynamically checking years of experience markers before modifying compensation rules.
*   **Automated Historical Discharges:** Safely handles high-volume patient discharge data cleanup tasks by executing conditional multi-table subquery deletions while managing active state flags (`SQL_SAFE_UPDATES`).

---

## 🛠️ Deployment & Execution Instructions

### Prerequisites
*   **Server Engine:** MySQL Server (v8.0 or newer recommended)
*   **Client Workspace:** Any standardized database development environment (e.g., MySQL Workbench, DBeaver, DataGrip, or Command Line Interface).

### Setup Pipeline
1. Clone this repository to your local system or copy the raw SQL script.
2. Open your preferred SQL database development tool and connect to your target server instance.
3. Execute the full script initialization file. This routine will automatically build the schema, set proper execution rules, inject verified baseline sample datasets, and run the complete analytical test pipeline.

## AUTHER NAME :- ANGEL BAREJA
