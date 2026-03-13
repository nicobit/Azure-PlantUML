
workspace "Tokenized US MMF Platform - Full On-Chain Architecture" "Full Structurizr DSL for a tokenized US Money Market Fund platform on Ethereum, including C1-C4 and runtime flows." {

    model {
        user = person "Investor" "Institutional or eligible investor subscribing, holding, transferring, and redeeming tokenized MMF shares."

        regulator = softwareSystem "SEC / Regulators" "US regulators receiving filings, disclosures, and audit evidence." "External"
        markets = softwareSystem "Financial Markets" "Underlying money market instruments and market counterparties." "External"
        irs = softwareSystem "IRS / Tax Reporting Authorities" "Receives tax reporting and withholding-related outputs." "External"

        mmf = softwareSystem "Tokenized MMF Platform" "Fully on-chain tokenized US Money Market platform on Ethereum." {

            portal = container "Investor Portal" "Web portal and API gateway for onboarding, servicing, subscriptions, statements, and support." "Web Application"
            compliance = container "Compliance & Identity Service" "KYC/AML, sanctions screening, jurisdiction checks, accreditation/eligibility checks, wallet binding, and case management." "Application"
            integration = container "Integration & Workflow Layer" "Orchestrates flows between on-chain events and institutional systems; manages notifications, workflow state, and reporting pipelines." "Application"
            reporting = container "SEC & Tax Reporting Service" "Generates SEC filings, investor statements, tax reporting, audit exports, and evidencing packages." "Application"
            monitoring = container "Monitoring, Risk & Audit" "Operational monitoring, blockchain analytics, alerting, cybersecurity telemetry, audit trail aggregation, and risk dashboards." "Application"
            oracleOps = container "Oracle Operations Service" "Controls, validates, signs, and publishes NAV, compliance, price, and liquidity data to oracle adapters." "Application"

            ethereum = container "Ethereum Smart Contract Platform" "Official on-chain shareholder register and transaction execution environment." "Ethereum" {
                tokenContract = component "MMF Token Contract" "Primary shareholder ledger storing balances and ownership state." "Solidity Smart Contract"
                accessControl = component "Access Control Module" "Role-based permissions for admin, issuer, redeemer, oracle operator, and compliance officer." "Solidity Module"
                complianceModule = component "Compliance Module" "Whitelist enforcement, sanctions/jurisdiction restrictions, transfer gating, and freeze controls." "Solidity Module"
                mintBurnModule = component "Mint/Burn Module" "Issues and redeems tokenized fund shares based on validated workflows and oracle/governance conditions." "Solidity Module"
                transferModule = component "Transfer Validation Module" "Validates peer-to-peer transfers, transfer restrictions, and optional ATS/broker-dealer flows." "Solidity Module"
                oracleAdapter = component "Oracle Adapter Module" "Consumes oracle-published NAV, compliance, liquidity, and price data on-chain." "Solidity Module"
                governanceModule = component "Governance & Pause Module" "Emergency pause, upgrade hooks, and governance-controlled configuration." "Solidity Module"
            }
        }

        kycProvider = softwareSystem "KYC / AML Provider" "External onboarding, sanctions, PEP, and identity verification provider." "External"
        fundAccounting = softwareSystem "Fund Accounting System" "Calculates NAV, yield, portfolio valuation, and accounting records." "External"
        custodian = softwareSystem "Custodian Bank" "Safekeeps assets, settles trades, manages cash, and supports redemptions." "External"
        portfolioManager = softwareSystem "Portfolio Management System" "Manages portfolio construction, liquidity metrics, and investment decisions." "External"
        brokerDealer = softwareSystem "Broker-Dealer / Distributor" "Optional regulated distributor and trading intermediary." "External"
        ats = softwareSystem "Alternative Trading System (Optional)" "Optional regulated secondary trading venue for tokenized shares." "External"
        oracleNetwork = softwareSystem "Oracle Network" "On-chain delivery channel for signed NAV, compliance, liquidity, and price data." "External"
        nodeProvider = softwareSystem "Ethereum Node / RPC Provider" "RPC and indexing infrastructure for blockchain access." "External"
        siem = softwareSystem "Enterprise SIEM / SOC" "Centralized security monitoring and incident response tooling." "External"

        user -> portal "Uses for onboarding, investing, statements, support"
        portal -> compliance "Submits onboarding data, wallet requests, service requests"
        compliance -> kycProvider "Performs identity, AML, sanctions, and eligibility checks"
        compliance -> portal "Returns onboarding and servicing status"
        compliance -> integration "Publishes wallet approval, restriction, or case events"
        portal -> integration "Submits subscription, redemption, servicing, and support requests"

        integration -> fundAccounting "Requests investment validation, NAV context, accounting updates"
        integration -> custodian "Triggers cash settlement and redemption payment workflows"
        integration -> reporting "Sends activity, positions, and filing data"
        integration -> monitoring "Publishes workflow and exception events"
        integration -> ethereum "Submits transaction instructions and listens to on-chain events"
        integration -> brokerDealer "Sends placement/distribution instructions" "Optional"
        integration -> ats "Sends settlement/trade status updates" "Optional"

        oracleOps -> fundAccounting "Receives NAV, valuation, and accounting data"
        oracleOps -> portfolioManager "Receives liquidity metrics, positions, and risk data"
        oracleOps -> compliance "Receives wallet approval/restriction state"
        oracleOps -> oracleNetwork "Publishes signed oracle payloads"
        oracleNetwork -> ethereum "Supplies on-chain NAV, price, liquidity, and compliance updates"

        portal -> reporting "Requests statements, confirmations, tax forms"
        reporting -> regulator "Submits SEC filings and disclosures"
        reporting -> irs "Submits tax reporting outputs"
        reporting -> portal "Provides statements, confirmations, notices"

        monitoring -> ethereum "Reads events, balances, supply, and contract state"
        monitoring -> nodeProvider "Consumes chain data, indexing, and logs"
        monitoring -> siem "Exports security telemetry and incidents"
        monitoring -> regulator "Provides audit evidence and investigation packages" "As required"

        fundAccounting -> custodian "Sends settlement instructions and cash movements"
        fundAccounting -> portfolioManager "Receives positions, instruments, and liquidity inputs"
        custodian -> markets "Executes trades, settlement, and holds assets"

        brokerDealer -> portal "Distributes product / supports investor access" "Optional"
        ats -> ethereum "Settles approved secondary trades on-chain" "Optional"

        user -> brokerDealer "Places orders through distributor" "Optional"
        user -> ats "Trades tokenized shares" "Optional"

        portal -> ethereum "Reads balances, holdings, and transaction status"
        compliance -> ethereum "Reads whitelist state and applies restrictions through governed transactions"
        reporting -> ethereum "Reads ownership, transfers, mint/burn events, and audit state"
        monitoring -> portal "Pushes alerts, service status, and incident banners"

        tokenContract -> accessControl "Uses"
        tokenContract -> complianceModule "Uses"
        tokenContract -> mintBurnModule "Uses"
        tokenContract -> transferModule "Uses"
        tokenContract -> oracleAdapter "Uses"
        tokenContract -> governanceModule "Uses"

        accessControl -> governanceModule "Controlled by"
        complianceModule -> accessControl "Checks roles"
        mintBurnModule -> accessControl "Checks roles"
        transferModule -> complianceModule "Checks transfer eligibility"
        oracleAdapter -> accessControl "Checks oracle operator permissions"
        governanceModule -> accessControl "Uses admin roles"

        tokenContract -> complianceModule "Checks wallet eligibility before mint/transfer/redeem"
        tokenContract -> oracleAdapter "Reads NAV / liquidity / price / compliance inputs"
        mintBurnModule -> oracleAdapter "Uses NAV and liquidity conditions"
        transferModule -> oracleAdapter "Uses compliance and trading status where needed"

        deploymentEnv = deploymentEnvironment "Production" {
            deploymentNode "Cloud Platform" "Azure / AWS / GCP" "Cloud" {
                deploymentNode "Web Tier" "Managed web hosting" "PaaS" {
                    containerInstance portal
                }
                deploymentNode "Application Tier" "Managed services / Kubernetes / VMs" "PaaS / Kubernetes" {
                    containerInstance compliance
                    containerInstance integration
                    containerInstance reporting
                    containerInstance monitoring
                    containerInstance oracleOps
                }
            }

            deploymentNode "Ethereum Mainnet / L2" "Target blockchain network" "Blockchain" {
                containerInstance ethereum
            }

            deploymentNode "External Providers" "Third-party services" "External" {
                infrastructureNode "KYC Provider API"
                infrastructureNode "Custodian Connectivity"
                infrastructureNode "Fund Accounting Connectivity"
                infrastructureNode "Oracle Network"
                infrastructureNode "Node / RPC Provider"
                infrastructureNode "SIEM / SOC"
            }
        }
    }

    views {
        systemContext mmf "C1-SystemContext" {
            include *
            autoLayout lr
            title "C1 - System Context"
            description "System context for the tokenized US MMF platform."
        }

        container mmf "C2-Containers" {
            include *
            exclude regulator
            exclude markets
            exclude irs
            autoLayout lr
            title "C2 - Container View"
            description "Containers inside the tokenized US MMF platform and key external dependencies."
        }

        component ethereum "C3-SmartContractComponents" {
            include *
            autoLayout lr
            title "C3 - Smart Contract Components"
            description "Detailed component breakdown of the Ethereum smart contract platform."
        }

        deployment mmf "Production" "C2-Deployment" {
            include *
            autoLayout lr
            title "Deployment View"
            description "Indicative deployment topology for the production environment."
        }

        dynamic mmf "Flow-Onboarding" {
            title "Dynamic Flow - Investor Onboarding and Wallet Whitelisting"
            user -> portal "1. Registers and submits onboarding data"
            portal -> compliance "2. Sends KYC/AML request and wallet details"
            compliance -> kycProvider "3. Verifies identity, AML, sanctions, eligibility"
            kycProvider -> compliance "4. Returns verification result"
            compliance -> integration "5. Publishes wallet approval event"
            integration -> oracleOps "6. Requests compliance oracle payload"
            oracleOps -> oracleNetwork "7. Publishes signed wallet approval"
            oracleNetwork -> ethereum "8. Delivers compliance update on-chain"
            portal -> ethereum "9. Reads wallet whitelist status"
            autoLayout lr
        }

        dynamic mmf "Flow-SubscriptionMint" {
            title "Dynamic Flow - Subscription and Mint"
            user -> portal "1. Submits investment order"
            portal -> integration "2. Creates subscription workflow"
            integration -> fundAccounting "3. Validates subscription and accounting context"
            fundAccounting -> custodian "4. Confirms cash settlement / funding"
            fundAccounting -> integration "5. Sends validated issuance context"
            integration -> oracleOps "6. Requests latest NAV oracle publication"
            oracleOps -> oracleNetwork "7. Publishes signed NAV"
            oracleNetwork -> ethereum "8. Updates on-chain NAV data"
            integration -> ethereum "9. Submits mint transaction"
            ethereum -> user "10. Investor wallet receives tokenized shares"
            reporting -> ethereum "11. Reads mint event for confirmations"
            portal -> reporting "12. Delivers confirmation / statement"
            autoLayout lr
        }

        dynamic mmf "Flow-Transfer" {
            title "Dynamic Flow - Wallet-to-Wallet Transfer"
            user -> ethereum "1. Initiates transfer to recipient wallet"
            ethereum -> oracleNetwork "2. Requests/uses current compliance and trading state"
            oracleNetwork -> ethereum "3. Supplies signed compliance context"
            ethereum -> compliance "4. Eligibility / restriction state reflected by governed rules"
            ethereum -> user "5. Executes or rejects transfer"
            monitoring -> ethereum "6. Monitors transfer event"
            reporting -> ethereum "7. Records transfer for audit trail"
            autoLayout lr
        }

        dynamic mmf "Flow-RedemptionBurn" {
            title "Dynamic Flow - Redemption and Burn"
            user -> ethereum "1. Initiates redemption request"
            ethereum -> integration "2. Emits redemption event"
            integration -> fundAccounting "3. Validates redemption and accounting treatment"
            fundAccounting -> custodian "4. Releases cash / settles redemption"
            custodian -> user "5. Pays redemption proceeds"
            integration -> ethereum "6. Submits burn completion transaction"
            reporting -> ethereum "7. Reads burn event for statements and filings"
            monitoring -> integration "8. Tracks workflow completion and exceptions"
            autoLayout lr
        }

        dynamic mmf "Flow-SECReporting" {
            title "Dynamic Flow - SEC and Tax Reporting"
            reporting -> ethereum "1. Reads ownership, mint/burn, transfer, and balances"
            reporting -> fundAccounting "2. Collects NAV, portfolio, and accounting data"
            reporting -> compliance "3. Collects servicing and compliance evidence"
            reporting -> regulator "4. Submits SEC filings / disclosures"
            reporting -> irs "5. Submits tax reporting outputs"
            portal -> reporting "6. Requests investor statements and notices"
            autoLayout lr
        }

        dynamic mmf "Flow-SecondaryTradingOptional" {
            title "Dynamic Flow - Optional Broker-Dealer / ATS Trading"
            brokerDealer -> ats "1. Places regulated secondary trade" 
            ats -> compliance "2. Checks investor / venue eligibility"
            compliance -> ats "3. Returns trading approval / restrictions"
            ats -> ethereum "4. Submits approved settlement transaction"
            ethereum -> reporting "5. Emits transfer event for audit/reporting"
            monitoring -> ethereum "6. Monitors venue-linked settlement"
            autoLayout lr
        }

        styles {
            element "Person" {
                background #08427b
                color #ffffff
                shape Person
            }
            element "Software System" {
                background #1168bd
                color #ffffff
            }
            element "Container" {
                background #438dd5
                color #ffffff
            }
            element "Component" {
                background #85bbf0
                color #000000
            }
            element "External" {
                background #999999
                color #ffffff
                border dashed
            }
            element "Ethereum" {
                background #6B46C1
                color #ffffff
                shape Hexagon
            }
            element "Solidity Smart Contract" {
                background #7C3AED
                color #ffffff
                shape Hexagon
            }
            element "Solidity Module" {
                background #C4B5FD
                color #000000
            }
            relationship "Optional" {
                dashed true
                color #999999
            }
        }

        theme default
    }
}
