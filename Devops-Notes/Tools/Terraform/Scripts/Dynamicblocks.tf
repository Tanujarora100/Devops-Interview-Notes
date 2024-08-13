variable "security_group_rules" {
    description = "List of security groups"
    type= list(object({
        type=string 
        from_port=number
        to_port=number
        protocol=string
        cidr_blocks=list(string)
    }))
    default=[{
        type="ingress"
        from_port=22
        to_port=22
        protocol="tcp"
        cidr_blocks=["0.0.0.0/0"]
    },
    {
        type="ingress"
        from_port=80
        to_port=80
        protocol="tcp"
        cidr_blocks=["0.0.0.0/0"]

    }
    ]
}
