resource "aws_vpc" "fundapps" {
  cidr_block           = "${var.cidr}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support   = "${var.enable_dns_support}"
  tags {
      Name = "VPC"
  }
}

resource "aws_internet_gateway" "fundapps" {
  vpc_id = "${aws_vpc.fundapps.id}"
  tags {
      Name = "IGW"
  }
}

resource "aws_route_table" "public" {
  vpc_id           = "${aws_vpc.fundapps.id}"
  tags {
      Name = "Public RT"
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.fundapps.id}"
}

resource "aws_subnet" "app" {
  vpc_id            = "${aws_vpc.fundapps.id}"
  cidr_block        = "${var.public_subnet[count.index]}"
  availability_zone = "${element(var.azs, count.index)}"
  count             = "${length(var.public_subnet)}"
}

resource "aws_subnet" "private" {
  vpc_id            = "${aws_vpc.fundapps.id}"
  cidr_block        = "${var.private_subnet[count.index]}"
  availability_zone = "${element(var.azs, count.index)}"
  count             = "${length(var.private_subnet)}"
}

resource "aws_subnet" "public" {
  vpc_id            = "${aws_vpc.fundapps.id}"
  cidr_block        = "${var.public_subnet[count.index]}"
  availability_zone = "${element(var.azs, count.index)}"
  count             = "${length(var.public_subnet)}"
  map_public_ip_on_launch = "${var.map_public_ip_on_launch}"
}

resource "aws_route_table_association" "public" {
  count          = "${length(var.public_subnets)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

output "app-subnets" {
  value = ["${aws_subnet.app.*.id}"]
}
