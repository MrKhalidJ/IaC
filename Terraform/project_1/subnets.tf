resource "aws_subnet" "stripes_subnet_public" {
    vpc_id = aws_vpc.stripes_vpc.id
    cidr_block = "10.0.0.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "eu-central-1a"

    tags = {
        Name: "stripes_subnet_public"
    }
}

resource "aws_subnet" "stripes_subnet_private" {
    vpc_id = aws_vpc.stripes_vpc.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "false"
    availability_zone = "eu-central-1b"

    tags = {
        Name: "stripes_subnet_private"
    }
}