## [next]

## 0.5.0 - 19/10/2023

- **BREAKING CHANGE**: Fix `canBackward` and `canForward` methods. These methods had a bad behaviour.
- Add `atStart` and `atEnd` attribute to indicate if the scrollbar is at the top or the bottom.
- Add `forwardPage` and `backwardPage` methods to move by the inside view distance (generally, this is the comportment of the page up/down).
- Give access to the method `scrollToPos`.

## 0.4.0 - 08/05/2023

- Add more checks to avoid error or division by zero ([#1](https://github.com/WinXaito/scroll_pos/pull/1))

## 0.3.0 - 24/12/2021

- *Breaking*: rename methods (replace terms `Top` and `Bottom` by `Start` and `End`, because the scrollbar can be horizontal)
- Fix `animate` parameter on differents methods (didn't work as expected)
- Add fields (`canScroll`, `canForward`, `canBackward`)

## 0.2.0 - 24/12/2021

- Add methods `forward` and `backward`

## 0.1.0 - 18/12/2021

- Initial Release