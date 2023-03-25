# ProxyScrape.sh

ProxyScrape.sh is a shell script designed to fetch SOCKS5 proxy lists from multiple sources, filter out working proxies, and save them in a list.

By acknowledging that proxy availability may vary due to factors such as geographical location, network routing, the target server being accessed, IP reputation, the target service's firewall, the script aims to provide a more reliable and accurate proxy list.  To achieve this, it tests the proxies directly through the your network and uses a customizable test endpoint, ensuring the results are tailored to the your specific environment and requirements.

## Features

- Fetch SOCKS5 proxy lists from multiple sources
- Deduplicate and filter out non-working proxies
- Test proxy connectivity with a customizable test target host
- Configure proxy timeout to suit user preferences

## Prerequisites

The script relies on the following command line tools, which are commonly available on most Linux systems:

- wc
- curl
- flock
- mktemp
- mv
- dos2unix
- sort
- uniq
- xargs

If any of these tools are missing, you can usually install them using your system's package manager (e.g., `apt`, `yum`, or `pacman`).

## Usage

1. Download the ProxyScrape.sh script
2. Set the script as executable with `chmod +x ProxyScrape.sh`
3. Run the script with `./ProxyScrape.sh`

## Customization

You can customize the following variables through environment variables to suit your needs:

- `SOCKS5_PROXY_LIST`: Path to the output file containing the list of working proxies. By default, the script creates a temporary file to avoid overwriting existing data and outputs the path after completion.
- `PROXY_TIMEOUT`: Timeout in seconds for testing proxy connectivity (default: `3`).
- `TEST_TARGET_HOST`: Target host used for testing proxy connectivity (default: `https://www.google.com`).

For example, you can set environment variables and run the script like this:

```sh
PROXY_TIMEOUT=5 TEST_TARGET_HOST=https://www.facebook.com ./ProxyScrape.sh
```

## License

GPL-2.0 (GNU GENERAL PUBLIC LICENSE Version 2)
