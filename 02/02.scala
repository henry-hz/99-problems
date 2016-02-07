object Problem02 extends App{
  // The standard functional approach is to recurse down the list until we hit
  // the end.  Scala's pattern matching makes this easy.
  def butLastRecursive[A](ls: List[A]): A = ls match {
    case h :: _ :: Nil  => h
    case _ :: tail => lastRecursive(tail)
    case _         => throw new NoSuchElementException
  }

  val list = List(1,2,3,4)
  val result = butLastRecursive(list)
  println(result)

}

