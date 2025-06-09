// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.


import Plot

struct Raw: Component {
 let text: String
 var body: Component {
     Node<HTML.BodyContext>.raw(text)
 }
}