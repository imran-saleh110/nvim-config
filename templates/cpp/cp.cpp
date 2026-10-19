/* --------------------------------------------------------------------
    File: {{FILENAME}}
    Date: {{DATE}}
    Author: {{AUTHOR}} 
   -------------------------------------------------------------------- */

#include <bits/stdc++.h>
#include <cstdint>
using namespace std;

typedef int64_t i64;
typedef uint64_t u64;

#define all(x) (x).begin(), (x).end()
#define endl "\n"
#define For(x, n) for(int64_t i=x; i < n; ++i)

auto start = chrono::steady_clock::now();

#define TIMER cerr << "Time: " \
    << chrono::duration<double>(chrono::steady_clock::now() - start).count() \
    << " s\n"

#define sim template < class c
#define ris return * this
#define dor > debug & operator <<
#define eni(x) sim > typename \
  enable_if<sizeof dud<c>(0) x 1, debug&>::type operator<<(c i) {
sim > struct rge { c b, e; };
sim > rge<c> range(c i, c j) { return rge<c>{i, j}; }
sim > auto dud(c* x) -> decltype(cerr << *x, 0);
sim > char dud(...);
struct debug {
#ifdef LOCAL
~debug() { cerr << endl; }
eni(!=) cerr << boolalpha << i; ris; }
eni(==) ris << range(begin(i), end(i)); }
sim, class b dor(pair < b, c > d) {
  ris << "(" << d.first << ", " << d.second << ")";
}
sim dor(rge<c> d) {
  *this << "[";
  for (auto it = d.b; it != d.e; ++it)
    *this << ", " + 2 * (it == d.b) << *it;
  ris << "]";
}
sim, class b dor(stack<c, b> d) {
  vector<c> v;
  while (!d.empty()) v.push_back(d.top()), d.pop();
  reverse(v.begin(), v.end());
  ris << range(v.begin(), v.end());
}
sim, class b dor(queue<c, b> d) {
  vector<c> v;
  while (!d.empty()) v.push_back(d.front()), d.pop();
  ris << range(v.begin(), v.end());
}
sim, class b, class p dor(priority_queue<c, b, p> d) {
  vector<c> v;
  while (!d.empty()) v.push_back(d.top()), d.pop();
  ris << range(v.begin(), v.end());
}
template <class Tuple, size_t... Is>
void print_tuple(const Tuple &d, index_sequence<Is...>) {
  size_t n = 0;
  ((*this << (n++ ? ", " : "") << get<Is>(d)), ...);
}
template <class... Ts>
debug &operator<<(const tuple<Ts...> &d) {
  *this << "{";
  print_tuple(d, index_sequence_for<Ts...>{});
  ris << "}";
}
#else
sim dor(const c&) { ris; }
#endif
};
#define imie(...) " [" << #__VA_ARGS__ ": " << (__VA_ARGS__) << "] "
#define dbg(a) debug() << a

mt19937_64 rng(chrono::steady_clock::now().time_since_epoch().count());
inline int gen_random(int l, int r) {return uniform_int_distribution<int>(l, r)(rng);}
const int mod = 1e9 + 7;


int main () {
  ios::sync_with_stdio(false);
  cin.tie(nullptr);

}
