#!/bin/bash

print_error() {
    echo -e "\e[91m[ERROR]\e[0m $1"
}

print_info() {
    echo -e "\e[96m[INFO]\e[0m $1"
}

print_warning() {
    echo -e "\e[93m[WARNING]\e[0m $1"
}

print_success() {
    echo -e "\e[92m[SUCCESS]\e[0m $1"
}
