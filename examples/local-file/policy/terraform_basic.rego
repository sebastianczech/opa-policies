package terraform.analysis

import input as tfplan

########################
# Parameters for Policy
########################

# acceptable score for automated authorization
blast_radius := 30

# weights assigned for each operation on each resource-type
weights := {
    "local_file": {"delete": 100, "create": 10, "modify": 1},
    "random_string": {"delete": 10, "create": 1, "modify": 1}
}

# Consider exactly these resource types in calculations
resource_types := {"local_file", "random_string", "random_id"}

#########
# Policy
#########

# 'allow' is true if score for the plan is acceptable and no changes are made to random_id
default allow := false
allow {
    score < blast_radius
    not touches_random_id
}

# compute the score for a Terraform plan as the weighted sum of deletions, creations, modifications
score := s {
    all := [ x |
            some resource_type
            crud := weights[resource_type];
            del := crud["delete"] * num_deletes[resource_type];
            new := crud["create"] * num_creates[resource_type];
            mod := crud["modify"] * num_modifies[resource_type];
            x := del + new + mod
    ]
    s := sum(all)
}

# whether there is any change to random_id
touches_random_id {
    all := resources["random_id"]
    count(all) > 0
}

####################
# Terraform Library
####################

# list of all resources of a given type
resources[resource_type] := all {
    some resource_type
    resource_types[resource_type]
    all := [name |
        name:= tfplan.resource_changes[_]
        name.type == resource_type
    ]
}

# number of creations of resources of a given type
num_creates[resource_type] := num {
    some resource_type
    resource_types[resource_type]
    all := resources[resource_type]
    creates := [res |  res:= all[_]; res.change.actions[_] == "create"]
    num := count(creates)
}


# number of deletions of resources of a given type
num_deletes[resource_type] := num {
    some resource_type
    resource_types[resource_type]
    all := resources[resource_type]
    deletions := [res |  res:= all[_]; res.change.actions[_] == "delete"]
    num := count(deletions)
}

# number of modifications to resources of a given type
num_modifies[resource_type] := num {
    some resource_type
    resource_types[resource_type]
    all := resources[resource_type]
    modifies := [res |  res:= all[_]; res.change.actions[_] == "update"]
    num := count(modifies)
}
