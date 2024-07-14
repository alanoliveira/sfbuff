export function setCookie(name, value) {
  document.cookie = `${name}=${value}; path=/; SameSite=Lax`
}
