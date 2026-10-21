# No-cache preview server for the scratchpad copy of a site.
# Usage: python3 serve.py <port> <folder>
import http.server, os, sys
class NoCache(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header("Cache-Control", "no-store")
        super().end_headers()
class Server(http.server.ThreadingHTTPServer):
    request_queue_size = 128  # the default (5) drops connections when a page loads many files at once
os.chdir(sys.argv[2])
Server(("", int(sys.argv[1])), NoCache).serve_forever()
