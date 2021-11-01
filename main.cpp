#include <fmt/chrono.h>

int main() {
  using namespace std::literals::chrono_literals;
  std::string s = fmt::format("I'd rather be {1} than {0}.", "right", "happy");
  return 0;
}