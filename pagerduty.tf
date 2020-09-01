################################################################################################
# This configuration requires a PagerDuty API Key and the Destination instance to have Prioties
# enabled to support event rule creation. Use the API key to generate the Priotiy ID's here:
# https://api-reference.pagerduty.com/#!/Priorities/get_priorities
# To Destroy the config run Destroy twice (perhaps a bug in the provider)
# working with Andres
################################################################################################
variable "pd_token" {
  type = string
}
provider "pagerduty" {
#TEST DEMO - currently https://wareagle.pagerduty.com/
#  WAR EAGLE token = "vgk-Vmo6ttpssbr4sxbk"
  token = var.pd_token
}

#################################################################################################
# Create PagerDuty teams - Automation, Operations, Banking Development (DevOps), Management
resource "pagerduty_team" "automation" {
  name        = "Automation"
  description = "All automation engineers"
}
resource "pagerduty_team" "Operations" {
  name        = "Operations Team"
  description = "Operations Team"
}
resource "pagerduty_team" "bankingDev" {
  name        = "Banking DevOps Team"
  description = "Banking DevOps Team"
}
resource "pagerduty_team" "Stakeholders" {
  name        = "Stakeholders"
  description = "Management Team"
}

################################################################################################



################################################################################################
# Create a PagerDuty users

resource "pagerduty_user" "bo_jackson" {
 name  = "Bo Jackson"
 email = "bo.jackson@example.com"
 color = "blue"
 role = "user"
}

resource "pagerduty_user" "jimh" {
  name  = "Jim TH"
  email = "jim@example.com"
  color = "blue"
  role = "user"
}

resource "pagerduty_user" "sam" {
  name  = "Sam Blake"
  email = "sam.blake@pagerduty.demo"
  color = "dark-goldenrod"
  role = "user"
}
resource "pagerduty_user" "bob" {
  name  = "Bob Smith"
  email = "bob.smith@pagerduty.demo"
  color = "chocolate"
  role = "limited_user"
}
resource "pagerduty_user" "dave" {
  name  = "Dave Bailey"
  email = "dave.bailey@pagerduty.demo"
  role = "user"
}
resource "pagerduty_user" "kate" {
  name  = "Kate Chapman"
  email = "kate.chapman@pagerduty.demo"
  role = "admin"
}
resource "pagerduty_user" "Derek" {
  name  = "DBA Derek"
  email = "dba.derek@pagerduty.demo"
}
resource "pagerduty_user" "Dora" {
  name  = "DBA Dora"
  email = "dba.dora@pagerduty.demo"
}
resource "pagerduty_user" "Nancy" {
  name  = "Network Nancy"
  email = "network.nancy@pagerduty.demo"
}
resource "pagerduty_user" "Norman" {
  name  = "Network Norman"
  email = "network.norman@pagerduty.demo"
}
resource "pagerduty_user" "Morris" {
  name  = "Management Morris"
  email = "management.morris@pagerduty.demo"
}
resource "pagerduty_user" "Martha" {
  name  = "Management Martha"
  email = "management.martha@pagerduty.demo"
}

################################################################################################


################################################################################################
# Assign the Users to the right Teams: -
resource "pagerduty_team_membership" "teamSam" {
  user_id = pagerduty_user.sam.id
  team_id = pagerduty_team.automation.id
}
resource "pagerduty_team_membership" "teamBob" {
  user_id = pagerduty_user.bob.id
  team_id = pagerduty_team.automation.id
}
resource "pagerduty_team_membership" "teamDave" {
  user_id = pagerduty_user.dave.id
  team_id = pagerduty_team.automation.id
}
resource "pagerduty_team_membership" "teamkate" {
  user_id = pagerduty_user.kate.id
  team_id = pagerduty_team.automation.id
}
resource "pagerduty_team_membership" "teamDerek" {
  user_id = pagerduty_user.Derek.id
  team_id = pagerduty_team.Operations.id
}
resource "pagerduty_team_membership" "teamDora" {
  user_id = pagerduty_user.Dora.id
  team_id = pagerduty_team.Operations.id
}
resource "pagerduty_team_membership" "teamNorman" {
  user_id = pagerduty_user.Norman.id
  team_id = pagerduty_team.Operations.id
}
resource "pagerduty_team_membership" "teamNancy" {
  user_id = pagerduty_user.Nancy.id
  team_id = pagerduty_team.Operations.id
}
resource "pagerduty_team_membership" "teamMorris" {
  user_id = pagerduty_user.Morris.id
  team_id = pagerduty_team.Stakeholders.id
}
resource "pagerduty_team_membership" "teamMartha" {
  user_id = pagerduty_user.Martha.id
  team_id = pagerduty_team.Stakeholders.id
}
################################################################################################


# 7 Days 604800 1 Day 86400 14 Days 1209600 12 Hours 43200
################################################################################################
# Create PagerDuty Schedules
resource "pagerduty_schedule" "automation_sch" {
  name      = "Automation On-call Schedule"
  time_zone = "America/Chicago"
  layer {
    name                         = "Weekly Rotation"
    start                        = "2018-11-06T20:00:00-10:00"
    rotation_virtual_start       = "2018-11-07T06:00:00+00:00"
    rotation_turn_length_seconds = 86400
    users                        = ["${pagerduty_user.sam.id}",
                                    "${pagerduty_user.bob.id}",
                                    "${pagerduty_user.dave.id}",
                                    "${pagerduty_user.kate.id}"]
	restriction {
      type              = "daily_restriction"
      start_time_of_day = "08:00:00"
      duration_seconds  = 43200
	}
  }
}
resource "pagerduty_schedule" "bankPayment" {
  name      = "Payment On-call Schedule"
  time_zone = "Europe/London"
  layer {
    name                         = "Daily Rotation"
    start                        = "2018-11-06T20:00:00-10:00"
    rotation_virtual_start       = "2018-11-07T06:00:00+00:00"
    rotation_turn_length_seconds = 86400
    users                        = ["${pagerduty_user.bob.id}",
                                    "${pagerduty_user.dave.id}",
                                    "${pagerduty_user.kate.id}"]
  }
}
resource "pagerduty_schedule" "bankApply" {
  name      = "Apply On-call Schedule"
  time_zone = "Europe/London"
    layer {
	name                         = "Daily Rotation"
    start                        = "2018-11-06T20:00:00-10:00"
    rotation_virtual_start       = "2018-11-07T06:00:00+00:00"
    rotation_turn_length_seconds = 86400
    users                        = ["${pagerduty_user.kate.id}"]
  }
}
resource "pagerduty_schedule" "bankTransfer" {
  name      = "Transfer On-call Schedule"
  time_zone = "Europe/London"
  layer {
    name                         = "Daily Rotation"
    start                        = "2018-11-06T20:00:00-10:00"
    rotation_virtual_start       = "2018-11-07T06:00:00+00:00"
    rotation_turn_length_seconds = 86400
    users                        = ["${pagerduty_user.dave.id}",
                                    "${pagerduty_user.kate.id}"]
  }
}
################################################################################################



################################################################################################
# Create PagerDuty EP's
resource "pagerduty_escalation_policy" "EngineeringEP" {
  name      = "eCommerce Engineering (EP)"
  num_loops = 2
  teams     = ["${pagerduty_team.automation.id}"]

  rule {
    escalation_delay_in_minutes = 10

    target {
      type = "schedule_reference"
      id   = pagerduty_schedule.automation_sch.id
    }
  }
}
resource "pagerduty_escalation_policy" "Bank-Payment" {
  name      = "Payment Team (EP)"
  num_loops = 2
  teams     = ["${pagerduty_team.bankingDev.id}"]

  rule {
    escalation_delay_in_minutes = 10

    target {
      type = "schedule_reference"
      id   = pagerduty_schedule.bankPayment.id
    }
  }
}
resource "pagerduty_escalation_policy" "Bank-Balance" {
  name      = "Balance Team (EP)"
  num_loops = 2
  teams     = ["${pagerduty_team.bankingDev.id}"]

  rule {
    escalation_delay_in_minutes = 10

    target {
      type = "schedule_reference"
      id   = pagerduty_schedule.automation_sch.id
    }
  }
}
resource "pagerduty_escalation_policy" "Bank-Transfer" {
  name      = "Transfer Team (EP)"
  num_loops = 2
  teams     = ["${pagerduty_team.bankingDev.id}"]

  rule {
    escalation_delay_in_minutes = 10

    target {
      type = "schedule_reference"
      id   = pagerduty_schedule.bankTransfer.id
    }
  }
}
resource "pagerduty_escalation_policy" "Bank-Apply" {
  name      = "Apply Team (EP)"
  num_loops = 2
  teams     = ["${pagerduty_team.bankingDev.id}"]

  rule {
    escalation_delay_in_minutes = 10

    target {
      type = "schedule_reference"
      id   = pagerduty_schedule.bankApply.id
    }
  }
}
################################################################################################



################################################################################################
# Create PagerDuty Services - eCommerce
resource "pagerduty_service" "eCommerce_FrontEnd" {
  name                    = "eCommerce FrontEnd"
  auto_resolve_timeout    = 14400
  acknowledgement_timeout = 600
  escalation_policy       = pagerduty_escalation_policy.EngineeringEP.id
  alert_creation          = "create_alerts_and_incidents"

  incident_urgency_rule {
    type = "constant"
    urgency = "severity_based"
  }
}
resource "pagerduty_service" "eCommerce_Search" {
  name                    = "eCommerce Search"
  auto_resolve_timeout    = 14400
  acknowledgement_timeout = 600
  escalation_policy       = pagerduty_escalation_policy.EngineeringEP.id
  alert_creation          = "create_alerts_and_incidents"

  incident_urgency_rule {
    type = "constant"
    urgency = "severity_based"
  }
}
resource "pagerduty_service" "eCommerce_Payment" {
  name                    = "eCommerce Payment"
  auto_resolve_timeout    = 14400
  acknowledgement_timeout = 600
  escalation_policy       = pagerduty_escalation_policy.EngineeringEP.id
  alert_creation          = "create_alerts_and_incidents"

  incident_urgency_rule {
    type = "constant"
    urgency = "severity_based"
  }

}
################################################################################################



################################################################################################
# Create PagerDuty Services - Banking
resource "pagerduty_service" "Bank-Payment" {
  name                    = "DutyBank Payment"
  auto_resolve_timeout    = 14400
  acknowledgement_timeout = 600
  escalation_policy       = pagerduty_escalation_policy.Bank-Payment.id
  alert_creation          = "create_alerts_and_incidents"
  alert_grouping          = "time"
  alert_grouping_timeout  = "10"

  incident_urgency_rule {
    type = "constant"
    urgency = "severity_based"
  }

}
resource "pagerduty_service" "Bank-Apply" {
  name                    = "DutyBank Apply"
  auto_resolve_timeout    = 14400
  acknowledgement_timeout = 600
  escalation_policy       = pagerduty_escalation_policy.Bank-Apply.id
  alert_creation          = "create_alerts_and_incidents"
  alert_grouping          = "time"
  alert_grouping_timeout  = "10"

  incident_urgency_rule {
    type = "constant"
    urgency = "severity_based"
  }
}
resource "pagerduty_service" "Bank-Balance" {
  name                    = "DutyBank Balance"
  auto_resolve_timeout    = 14400
  acknowledgement_timeout = 600
  escalation_policy       = pagerduty_escalation_policy.Bank-Balance.id
  alert_creation          = "create_alerts_and_incidents"
  alert_grouping          = "time"
  alert_grouping_timeout  = "10"

  incident_urgency_rule {
    type = "constant"
    urgency = "severity_based"
  }
}
resource "pagerduty_service" "Bank-Transfer" {
  name                    = "DutyBank Transfer"
  auto_resolve_timeout    = 14400
  acknowledgement_timeout = 600
  escalation_policy       = pagerduty_escalation_policy.Bank-Transfer.id
  alert_creation          = "create_alerts_and_incidents"
  alert_grouping          = "intelligent"

  incident_urgency_rule {
    type = "constant"
    urgency = "severity_based"
  }

}

################################################################################################
# Integrations
################################################################################################

resource "pagerduty_service_integration" "bank-Transfer-Generic-API_V2" {
  name    = "Generic API Service Integration V2"
  type    = "events_api_v2_inbound_integration"
  service = pagerduty_service.Bank-Transfer.id
}

resource "pagerduty_service_integration" "Bank-Transfer-CET" {
  name    = "Custom Event Transformer"
  service = pagerduty_service.Bank-Transfer.id
  vendor  = data.pagerduty_vendor.custom.id
}

data "pagerduty_vendor" "custom" {
  name = "Custom Event Transformer"
}

################################################################################################
# Test CET Integrations work in progress
################################################################################################

# data "http" "CET-test" {
#  url = "https://events.pagerduty.com/integration/${pagerduty_service_integration.Bank-Transfer-CET.integration_key}/enqueue"
#  }

################################################################################################

# Event Rules Require Priority enabled P1 PBB4FSI P2 PY1GEDV P3 PUSVE15 P4 PQG7DOF P5 PQG7DOF
# 2/1/2020 6am epoch timestamp 1580558400000 calulate using and convert to milliseconds
# https://www.freeformatter.com/epoch-timestamp-to-date-converter.html
################################################################################################
resource "pagerduty_event_rule" "one" {
    action_json = jsonencode([
        [
            "route",
            pagerduty_service.Bank-Transfer.id
        ],
        [
            "severity",
            "warning"
        ],
        [
            "annotate",
            "1 Managed by terraform"
        ],
        [
            "priority",
            "PBB4FSI"
        ]
    ])
    condition_json = jsonencode([
        "and",
        ["contains",["path","payload","source"],"website"],
        ["contains",["path","headers","from","0","address"],"homer"]
    ])
    advanced_condition_json = jsonencode([
        [
            "scheduled-weekly",
            1580558400000,
            3600000,
            "America/Chicago",
            [
                1,
                2,
                3,
                5,
                7
            ]
        ]
    ])
}
resource "pagerduty_event_rule" "two" {
    action_json = jsonencode([
        [
            "route",
            pagerduty_service.Bank-Transfer.id
        ],
        [
            "severity",
            "warning"
        ],
        [
            "annotate",
            "2 Managed by terraform"
        ],
        [
            "priority",
            "PY1GEDV"
        ]
    ])
    condition_json = jsonencode([
        "and",
        ["contains",["path","payload","source"],"website"],
        ["contains",["path","headers","from","0","address"],"homer"]
    ])
    depends_on = [pagerduty_event_rule.one]
}
