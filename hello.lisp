(defun hello-world ()
  (format t "hello world!"))

(defun verbose-sum (x y)
  "Sum any two numbers after prining a message."
  (format t "Summing ~d and ~d. ~%" x y)
  (+ x y))


;; 可选形参
(defun foo (a b &optional c d)(list a b c d))

;; 默认值
(defun foo (a &optional (b 10)) (list a b))

;; 获取形参是否是使用默认值
(defun foo (a b &optional (c 3 c-supplied-p))
  (list a b c c-supplied-p))

;;剩余形参
;;; (defun foo (steam string &rest values) ...)
;;; (defun foo (&rest numbers) ...)

;; 关键字形参
(defun foo (&key a b c) (list a b c))
(foo :a 1 :b 2 :c 2)

;; 关键字形参 默认值 及 是否使用默认值
(defun foo (&key (a 0) (b 0 b-supplied-p) (c (+ a b)))
  (list a b c b-supplied-p))


;; 指定形参的关键字
(defun foo (&key ((:apple a)) ((:box b) 0) ((:charlie c) 0 c-supplied-p))
  (list a b c c-supplied-p))


;; 混合不同的形参类型
(defun foo (x &optional y &key z) (list x y z))

(defun foo (&rest rest &key a b c) (list rest a b c))

(foo :a 1 :b 2 :c 3)


;; 默认最后一个表达式被作为整个函数的返回值
(defun foo (a b)
  (+ a b)
  (- a b))

;; return-from 返回值
(defun foo (n)
  (dotimes (i 10)
    (dotimes (j 10)
      (when (> (* i j) n)
        (return-from foo (list i j))))))

;; 获取一个函数对象的方法
(function foo)
#'foo


;; 使用函数对象调用
(foo 10)
(funcall #'foo 10)

;; funcall 建设性的用法 接收函数对象作为实参
(defun plot(fn min max step)
  (loop for i from min to max by step do
       (loop repeat (funcall fn i) do (format t "*"))
       (format t "~%")))

(plot #'exp 0 4 1/2)

;; apply 第一个参数是一个函数对象 最后一个是列表
(defvar plot-data '(#'exp 0 4 1/2))

;; (apply #'plot plot-data)

(apply 'cons '((+ 2 3) 4))

;;匿名参数

(funcall #'(lambda (x y)(+ x y)) 2 5)

((lambda (x y)(+ x y)) 2 5)


(plot #'(lambda (x) (* 2 x)) 0 10 1)

;;变量
(let ((x 10) (y 20) (z 30))
  (+ x y z))

(defun foo (x)
  (format t "Parameter: ~a~%" x)
  (let ((x 2))
    (format t "Quter let: ~a~%" x)
    (let ((x 3))
      (format t "Inner let: ~a~%" x))
    (format t "Quter let: ~a~%" x))
  (format t "Parameter: ~a~%" x))

(dotimes (x 10) (format t "~d " x))

;; let* 每个变量的初始值形式,都可以引用到那些在变量列表中早点引入的变量

(let* ((x 10)
       (y (+ x 10)))
  (list x y))

;;词法变量盒闭包
(let ((count 0)) #'(lambda()(setf count (+ 1 count))))

(defparameter *fn* (let ((count 0)) #'(lambda()(setf count (+ 1 count)))))


(let ((count 0)) (list
                  #'(lambda()(incf count))
                  #'(lambda()(decf count))
                  #'(lambda() count)))
;;动态变量 约定 以*开始和结尾的名字表示全局变量
(defvar *count* 0
  "Count of widgets made so far.")

(defparameter *gap-tolerance* 0.001
  "Tolerance to be allowed in widget gaps.")

;; defparameter 总是将初始值赋给命名的变量
;; defvar 只有当变量未定义时才这样做

(defun increment-widget-count()(incf *count*))


;; (let ((*standard-output* *some-other-stream*))
;;   (stuff))

(defvar *x* 10)
(defun foo()(format t "X: ~d~%" *x*))

(defun bar()
  (foo)
  (let ((*x* 20)) (foo))
  (foo))

(defun foo()
  (format t "Before assignment~18tX: ~d~%" *x*)
  (setf *x* (+ 1 *x*))
  (format t "After assignment~18tX: ~d~%" *x*))

;;常量 约定 以+开始和结尾的名字表示常量
;; (defconstant name initial-value-form [ docoumentation-string ])

;;赋值
;; (setf place value)

(setf *x* 10)

(defun foo (x) (setf x 10))


(let ((y 20))
  (foo y)
  (print y))

;; (setf x 1)
;; (setf y 2)

;;(setf x 1 y 2)

;;(setf x (setf y (random 10)))

;;广义赋值

;; Simple variable : (setf x 10)
;; Array : (setf (ardf a 0) 10)
;; Hash table : (setf (gethash 'key hash) 10)
;; Slot named 'filed' : (setf (field 0) 10)

;;(incf x) === (setf x (+ x 1))
;;(decf x) === (setf x (- x 1))
;;(incf x 10) === (setf x (+ x 10))


;; (incf (aref *array* (random (length *array*))))
;; (setf (aref *array* (random (length *array*)))
;;       (+ 1 (aref *array* (random *array*))))

;; rotatef 交换值的修改宏
;; (rotatef a b)
;; (let ((tmp a)) (setf a b b tmp) nil)

;; shiftf 将值向左侧移动
;; (shiftf a b 10)
;; (let ((tmp a)) (setf a b b 10) tmp)


;; 宏

;; (if condition then-form [else-form])

(if (> 2 3) "Yup" "Nope")

(if (> 2 3) "Yup")

(if (> 3 2) "Yup" "Nope")


;; (when (spam-p current-message)
;;   (file-in-spam-folder current-message)
;;   (update-spam-database current-message))


;; (unless (spam-p current-message)
;;   (file-in-spam-folder current-message)
;;   (update-spam-database current-message))


;; (cond
;;   (a (do-x))
;;   (b (do-y))
;;   (c (do-z)))


;; (dolist (var list-form)
;;   body-form*)

(dolist (x '(1 2 3)) (print x))

(dolist (x '(1 2 3)) (print x) (if (evenp x ) (return)))

;; (dotimes (var count-form)
;;   body-form*)

(dotimes (i 4) (print i))

(dotimes (x 20)
  (dotimes (y 20)
    (format t "~3d " (* (1+ x) (1+ y))))
  (format t "~%"))


(dotimes (x 10)
  (dotimes (y 10)
    (format t "~3d " (* (+ 1 x) (+ 1 y))))
  (format t "~%"))


;; (do (variable-definition*)
;;     (end-test-form result-form*)
;;   statement*)

(do ((n 0 (1+ n))
     (cur 0 next)
     (next 1 (+ cur next)))
    ((= 10 n) cur))

(do ((i 0 (1+ i)))
    ((>= i 4))
  (print i))

(dotimes (i 4) (print i))

(defvar *some-future-date*)

(setf *some-future-date* (+ (get-universal-time) 1000))


(do ()
    ((> (get-universal-time) *some-future-date*))
  (format t "Wating~%")
  (sleep 60))


(loop
   (when (> (get-universal-time) *some-future-date*)
     (return))
   (format t "Wating~%")
   (sleep 60))

(do ((nums nil) (i 1 (1+ i)))
    ((> i 10) (nreverse nums))
  (push i nums))

(loop for i from 1 to 10 collecting i)

(loop for x from 1 to 10 summing (expt x 2))

(loop for x across "the quick brown fox jumps over the lazy dog"
   counting (find x "aeiou"))


;; across and below collecting counting finally for from summing then to 循环关键字
(loop for i below 10
   and a = 0 then b
   and b = 1 then (+ b a)
   finally (return a))


;; 定义宏

;; 宏运行的时期被称为宏展开期(macro expansion time)
;; 宏展开期无法访问那些仅存在与运行期的数据

;; (defmacro when (condition &rest body)
;;   `(if ,condition (progn ,@body)))

;; 编写宏的步骤
;; 1 编写示例的宏调用以及它应当展开成的代码,反之亦然;
;; 2 编写从示例调用的参数中生成手写展开式的代码
;; 3 确保宏抽象不产生"泄漏"

(defun primep (number)
  (when (> number 1)
    (loop for fac from 2 to (isqrt number) never (zerop (mod number fac)))))

(defun next-primep (number)
  (loop for n from number when (primep n) return n))


;; 素数
(do-primes (p 0 19)
  (format t "~d " p))

(do ((p (next-primep 0) (next-primep (1+ p))))
    ((> p 19))
  (format t "~d " p))


(defmacro do-primes (var-and-range &rest body)
  (let ((var (first var-and-range))
        (start (second var-and-range))
        (end (third var-and-range)))
    `(do ((,var (next-primep ,start) (next-primep (1+ ,var))))
         ((> ,var ,end))
       ,@body)))

;; &body 与 &rest 在语义上是等价的
(defmacro do-primes ((var start end) &body body)
  `(do ((,var (next-primep ,start) (next-primep (1+ ,var))))
       ((> ,var ,end))
     ,@body))

;; 没有 "@" 符号,逗号会导致子表达式的值被原样包含
;; 有了 "@" 符号,其值(必须是一个列表) 可被"拼接" 到其所在的列表中


`(a (+ 1 2) c)
(list 'a '(+ 1 2) 'c)


`(a ,(+ 1 2) c)
(list 'a (+ 1 2) 'c)


`(a (list 1 2) c)
(list 'a '(list 1 2) 'c)

`(a ,(list 1 2) c)
(list 'a (list 1 2) 'c)

`(a ,@(list 1 2) c)
(append (list 'a) (list 1 2) (list 'c))


(defmacro do-primes-a ((var start end) &body body)
  (append '(do)
          (list (list (list var
                            (list 'next-primep start)
                            (list 'next-primep (list '1+ var)))))
          (list (list (list '> var end)))
          body))


;; macroexpand-1 接收任何Lisp表达式作为参数并返回做宏展开一层的结果

(macroexpand-1 '(do-primes (p 0 19) (format t "~d " p)))

;; 修复随机end值时重复求值的问题
(defmacro do-primes ((var start end) &body body)
  `(do ((ending-value ,end)
        (,var (next-primep ,start) (next-primep (1+ ,var))))
       ((> ,var ending-value))
     ,@body))


;; 当宏展开被求值时,传递给end的表达式将在传递给start的表达式之前求值
;; 这与他们在宏调用中的顺序相反



(defmacro do-primes ((var start end) &body body)
  `(do ((,var (next-primep ,start) (next-primep (1+ ,var)))
        (ending-value ,end))
       ((> ,var ending-value))
     ,@body))

;;(do-primes (ending-value 0 10)) 将无法运行
(let ((ending-value 0))
  (do-primes (p 0 10)
    (incf ending-value p))
  ending-value)


;; 函数 gensym  在每次被调用时返回唯一的符号. 这是一个没有被Lisp读取器读过的符号并且永远不会被读到
(defmacro do-primes ((var start end) &body body)
  (let ((ending-value-name (gensym)))
    `(do ((,var (next-primep ,start) (next-primep (1+ ,var)))
          (,ending-value-name ,end))
         ((> ,var ,ending-value-name))
       ,@body)))

;; 除非有特殊理由,否则需要将展开式中的任何子形式放在一个位置上,使其求值顺序与宏调用的子形式相同
;; 除非有特殊理由,否则需要确保子形式仅被求值一次,方法是在展开式中创建变量来持有求值参数形式所得到的值,然后在展开式中所有需要用到该值的地方使用这个变量.
;; 在宏展开期使用 gensym 来创建展开式中用到的变量名

;; 用于编写宏的宏

(defmacro do-primes ((var start end) &body body)
  (with-gensyms (ending-value-name)
    `(do ((,var (next-primep ,start) (next-primep (1+ ,var)))
          (,ending-value-name ,end))
         ((> ,var ,ending-value-name))
       ,@body)))

(defmacro with-gensyms ((&rest names) &body body)
  `(let ,(loop for n in names collect `(,n (gensym)))
     ,@body))


;; do-primes 展开
;; (let ((ending-value-name (gensym)))
;;   `(do ((,var (next-primep ,start) (next-primep (1+ var)))
;;         (,ending-value-name ,end))
;;        ((> ,var ,ending-value-name))
;;      ,@body))

(defmacro do-primes ((var start end) &body body)
  (once-only (start end)
    `(do ((,var (next-primep ,start) (next-primep (1+ ,var))))
         ((> ,var ,end))
       ,@body)))

;; 用来生成特定顺序仅求值特定宏参数一次的代码
(defmacro once-only ((&rest names) &body body)
  (let ((gensyms (loop for n in names collect (gensym))))
    `(let (,@(loop for g in gensyms collect `(,g (gensym))))
       `(let (,,@(loop for g in gensyms for n in names collect ``(,,g ,,n)))
          ,(let (,@(loop for n in names for g in gensyms collect `(,n ,g)))
             ,@body)))))



;; 数字
;; #b 二进制
;; #o 八进制
;; #x 十六进制
;; #nR n代表进制数

;; 指数标记由单个字母后跟一个可选符号和一个数字序列组成,其代表10的指数用来跟指数标记前的数字向相乘
;; 指数标记 s,f,d,l分别代表短型,单精度,双精度以及长型
;; 字母e代表默认表示方式(单浮点数)

;; 复数 #C或#c跟上一个由两个实数所组成的列表,分别代表复数的实部和虚部.

;; floor 向负无穷方向截断;返回小于或等于实参的最大整数
;; ceiling 向正无穷方向截断;返回大于或等于参数的最小整数
;; truncate 向零截断,对于正实参而言,它等价与floor,而对于负实参则等价与ceiling
;; round 四舍五入
;; mod rem 返回两个实数截断相除得到的模和余数

;; /= 全部实参都是不同值时才返回真

;; 高等数学

;; 对数函数 log
;; 指数函数 exp 和 expt
;; 基本三角函数 sin cos tan 逆函数 asin acos atan
;; 双曲函数 sinh cosh tanh 逆函数 asinh acosh atanh


(string= "foobarbaz" "quuxbarfoo" :start1 3 :end1 6 :start2 4 :end2 7)

;; 集合

;; 向量
;; 定长向量与java等语言里的数组非常相识;一块数据头以及一段保存向量元素的连续内存区域
;; 变长向量抽象了实际存储,允许向量随着元素的增加和移除而增大和减小
;; vector 来生成含有特定值的定长向量;该函数接受任意数量的参数并返回一个新分配的含有那些参数的定长向量

(vector) #()
(vector 1) #(1)

;; make-array 用来创建任何维度的数组以及定长和变长向量;make-array的一个必要参数是一个含有数组维度的列表

(make-array 5 :initial-element nil)

;; makr-array 用来创建变长向量
;;
(make-array 5 :fill-pointer 0)

(defparameter *x* (make-array 5 :fill-pointer 0))

;; vector-push 在填充指针的当前值上添加一个元素并将填充指针递增一次,并返回新元素被添加位置的索引
;; vector-pop 返回最近推入的项,并在该过程中递减填充指针

;; 带有填充指针的也不是完全变长的
;; 需要传递 :adjustable

(make-array 5 :fill-pointer 0 :adjustable t)

;; vector-push-extend
;; 向一个已满的向量中推入元素时,能自动扩展该数组

;; 向量的子类型

;; 特化字符串
(make-array 5 :fill-pointer 0 :adjustable t :element-type 'character)

;; 位向量 是元素全部由0或1所组成的向量
(make-array 5 :fill-pointer 0 :adjustable t :element-type 'bit)

;; length 接受序列作为其唯一的参数并返回它含有的元素数量
;; elt 接受序列和从0到序列长度(左闭右开区间)的整数索引,并返回对应的元素.
;; elt 将在索引超出边界时报错
(defparameter *x* (vector 1 2 3))
(length *x*)
(elt *x* 0)
(elt *x* 1)
(elt *x* 2)
(elt *x* 3)

;; elt 也支持setf的位置,可以设置一个特定元素的值
(setf (elt *x* 0) 10)

;; |名称|所需参数|返回|
;; |count|项和序列|序列中出现某项的次数|
;; |find|项和序列|项或NIL|
;; |position|项和序列|序列中的索引NIL|
;; |remove|项和序列|项的实例被移除后的序列|
;; |substitute|新项,项和序列|项的实项被新项替换后的序列|


(count 1 #(1 2 1 2 3 1 2 3 4))
(remove 1 #(1 2 1 2 3 1 2 3 4))
(remove 1 '(1 2 1 2 3 1 2 3 4))
(remove #\a "foobarbaz")
(substitute 10 1 #(1 2 1 2 3 1 2 3 4))

(find 1 #(1 2 1 2 3 1 2 3 4))
(find 1- #(1 2 2 3 3 1 2 3 4))
(position 1 #(1 2 1 2 3 1 2 3 4))

;; 可以使用关键参数改变五个函数的行为
;; :test 关键字来传递一个接受两个参数并返回一个布尔值的函数.如果有了这一个函数,他将使用该函数代替默认的对象等价性测试EQL来比较序列中的每一个元素

(count "foo" #("foo" "bar" "baz") :test #'string=)
;; :test 相反的布尔结果
(count "foo" #("foo" "bar" "baz" :test (complement #'string=)))

;; :key 关键字可以传递单参数函数,其被调用在序列的每个元素上抽取出一个关键值,该值随后会和替代自身的项对比
(find 'c #((a 10) (b 20) (c 30) (d 40)) :key #'first)

(find 30 #((a 10) (b 20) (c 30) (d 40)) :key #'second)

;; :start 和 :end 参数提供边界指示


;; 非NIL的:from-end参数,序列的元素将以相反的顺序被检查

(find 'a #((a 10) (b 20) (a 30) (b 40)) :key #'first)

(find 'a #((a 10) (b 20) (a 30) (b 40)) :key #'first :from-end t)


;; :count 匹配次数

(remove #\a "foobarbaz" :count 1)

(remove #\a "foobarbaz" :count 1 :from-end t)



;; :from-end 可以影响传递任何:test和:key函数的元素的顺序

(defparameter *v* #((a 10) (b 20) (a 30) (b 40)))
(defun verbose-first(x)(format t "Looking at ~s~%" x) (first x))

(count 'a *v* :key #'verbose-first)
(count 'a *v* :key #'verbose-first :from-end t)



;; |参数|含义|默认值|
;; |:test|两参数函数用来比较元素(或由:key函数解出的值)和项|EQL|
;; |:key|单参数函数用来从实际的序列元素中解出用于比较的关键字值;NIL表示原样采用序列元素|NIL|
;; |:start|子序列的起始索引(含)|0|
;; |:end|子序列的终止索引(不含).NIL表示到序列的结尾|NIL|
;; |:from-end|如果为真,序列将以相反的顺序遍历,从尾到头|NIL|
;; |:count|数字代表需要移除或替换的元素个数,NIL代表全部(仅用于remove和substitute)|NIL|

;; 高阶函数变体
;; -if 用于计数,查找,移除以及替换序列中那些函数参数返回真元素
;; -if-not 用于计数,查找,移除以及替换序列中那些函数参数不返回真元素
;; evenp 偶数 返回T 奇数返回NIL

(count-if #'evenp #(1 2 3 4 5))
(count-if-not #'evenp #(1 2 3 4 5))

(position-if #'digit-char-p "adcd0001")

(remove-if-not #'(lambda(x)(char= (elt x 0) #\f))
               #("foo" "barf" "baz" "foom"))

(count-if #'evenp #((1 a) (2 b) (3 c) (4 d) (5 e)) :key #'first)

(count-if-not #'evenp #((1 a) (2 b) (3 c) (4 d) (5 e)) :key #'first)

(remove-if-not #'alpha-char-p
               #("foo" "bar" "1bsz") :key #'(lambda(x) (elt x 0)))


;; remove-duplicates 将每个重复的元素移除到只剩下一个实例
(remove-duplicates #(1 2 1 2 3 1 2 3 4))


;; 序列上的操作
;; copy-seq 和 reverse 都接受单一的序列参数并返回一个相同类型的新序列
;; copy-seq 返回的序列包含与其参数相同的元素
;; reverse 返回的序列则含有顺序相反的相同元素
;; concatenate 创建一个将任意数量序列连接在一起的新序列 必需被显示指定产生何种类型的序列

(concatenate 'vector #(1 2 3) '(4 5 6))
(concatenate 'list #(1 2 3) '(4 5 6))
(concatenate 'string "abc" '(#\d #\e #\f))

;; 排序与合并

(sort (vector "foo" "bar" "baz") #'string<)
;; sort和stable-sort stable-sort 可以保证不会重拍任何被该谓词视为等价的元素
;; 能接受:key

;; merger 接受两个序列和一个谓词，并返回按照该谓词合并这两个序列所产生的序列
(merge 'vector #(1 3 5) #(2 4 6) #'<)
(merge 'list #(1 3 5) #(2 4 6) #'<)

;; 子序列操作
;; subseq 解出序列中从一个特定索引开始并延续到一个特定终止索引或结尾处的子序列
(subseq "foobarbaz" 3)

(subseq "foobarbaz" 3 6)
;; subseq 也支持setf，但不会扩大或缩小一个序列；如果新的值和将被替换的子序列具有不同长度，那么两者中较短的那一个将决定有多少个字符被实际改变
(defparameter *x* (copy-seq "foobarbaz"))

(setf (subseq *x* 3 6) "xxx")

(setf (subseq *x* 3 6) "abcd")

(setf (subseq *x* 3 6) "xx")

;; fill 函数来将一个序列的多个元素设置到单个值上。所需的参数是一个序列以及所填充的值
(fill (list 0 1 2 3 4 5) '(444))
(fill (copy-seq "01234") #\e :start 3)

;; search 在一个序列中查找一个子序列

(position #\b "foobarbaz")
(search "bar" "foobarbaz")

;; mismatch 接受两个序列并返回第一对不相匹配的元素的索引
(mismatch "foobarbaz" "foom")

;; 序列谓语
;; every,some,notany,notevery 第一个参数谓词，其余的参数都是序列
;; every 在谓词失败时返回假；如果谓词总被满足，它返回真
;; some 返回由谓词所返回的第一个非NIL值，或者在谓词永远特不到满足时返回假
;; notany 在谓词满足时返回假；或者在从未满足时返回真
;; notevery 在谓词失败时返回真，或是在谓词总是满足时返回假
(every #'evenp #(1 2 3 4 5))
(some #'evenp #(1 2 3 4 5))
(notany #'evenp #(1 2 3 4 5))
(notevery #'evenp #(1 2 3 4 5))

;; 序列映射函数
;; map 接受一个参数函数和n个序列,返回一个新的序列,由那些将函数应用在序列的相继元素上所得到的结果组成;map 需要被告知其所创建序列的类型
(map 'vector #'* #(1 2 3 4 5) #(10 9 8 7 6))


;; map-into 与map 相似,但不产生给定类型的新序列,而是将放置在一个作为第一个参数传递的序列中

(let ((a (make-array 5  :initial-element 1))
      (b (make-array 5  :initial-element 2))
      (c (make-array 5  :initial-element 3)))
  (map-into a #'+ a b c))

;; 如果序列长度不同;将只影响与最短序列元素数量相当的那些元素
;; map-into 不会扩展一个可调整大小的向量

;; reduce 映射在单个序列上,先将一个两个参数应用到序列的最初两个元素,再将函数返回值和序列后续元素继续用于该函数
(reduce #'+ #(1 2 3 4 5 6 7 8 9 10))

(reduce #'max #(1 2 3 4 5 6 7 8 9))

;; reduce 也接受关键参数 (:key :from-end :start :end) 和一个 专有 :intial-value 指定一个值,在逻辑上被放置在序列的第一个元素之前
(reduce #'+ #(1 2 3 4) :initial-value -10)

(reduce #'+ #(1 2 3 4) :initial-value -10 :from-end t)

;; 哈希表
;; make-hash-table 创建一个哈希表,其认定两个建等价,当且仅当他们在eql的意义上是相同的对象

;; 哈希表实际上需要两个函数:一个等价性函数;一个以一种和等价函数最终比较两个建时相兼容的方式,用来从建中计算出一个数值的哈希码的哈希函数
;; 当用字符串为键时,这时候需要equal哈希表 (make-hash-table :test equal)
;; :test 关键字 只能是eq,eql,equal,equalp

;; gethash 对哈希表元素的访问 接受两个参数,及键和哈希表,并返回保存在哈希表中相应键虾的值或时nil
;; gethash 实际上是返回两个值;主值是保存在给定键下的值或nil;从值是一个布尔值
(defparameter *h* (make-hash-table))

(gethash 'foo *h*)

(setf (gethash 'foo *h*) 'quux)

(gethash 'foo *h*)


;; 多重返回值

;; 使用multiple-value-bind 宏来利用gethash额外返回值
(defun show-value(key hash-table)
  (multiple-value-bind (value present) (gethash key hash-table)
    (if present
        (format nil "Value ~a actually present." value)
        (format nil "Value ~a because key not found." value))))

(setf (gethash 'bar *h*) nil)

(show-value 'foo *h*)
(show-value 'bar *h*)
(show-value 'baz *h*)

;; 由于将一个键下面的值设置成nil 会造成把键留在表中 so 需要remhash 移除 键值对
;; clrhash 清除哈希表中所有键值对
(remhash 'foo *h*)
(clrhash *h*)

;; 哈希表迭代

;; maphash
(maphash #' (lambda (k v) (format t "~a => ~a ~%" k v)) *h*)

;; 在迭代一个哈希表的过程中,向其中添加或移除元素的后果没有被指定(并且可能会很坏)
;; 但可以 setf与gethash 一起使用来修改当前值,也可以使用remhash来移除当前向

(maphash #' (lambda (k v)(when (< v 10) (remhash k *h*))) *h*)

;; loop

(loop for k being the hash-keys in *h* using (hash-value v)
   do (format t "~a => ~a ~%" k v))

;; 列表

;; 对点单元  cons

(cons 1 2)

;; 对点单元中的两个值分别称为car和cdr,同时也是用来访问这两个值的函数名

(car (cons 1 2))
(cdr (cons 1 2))

;; car 和 cdr 能够支持setf

(defparameter *cons* (cons 1 2))

*cons*

(setf (car *cons*) 10)

(setf (cdr *cons*) 20)

(cons 1 nil)

(cons 1 (cons 2 nil))

(cons 1 (cons 2 (cons 3 nil)))


(list 1)
(list 1 2)
(list 1 2 3)

(1)
(2)
(3)

;; 在列表中使用first he  rest 分别时car和cdr的同一词

(defparameter *list* (list 1 2 3 4))
(first *list*)
(rest *list*)
(first (rest *list*))

;; 由于列表可以将其他列表作为元素,因此可以用他们来表示任意深度与复杂度的树


;; 函数式编程和列表

;; 函数式编程的本质在于,程序完全没有副作用的函数组成,也就是说,函数完全基于其参数的值来计算结果.
;; 函数式风格的好处在于它使得程序更易于理解

;; append 必须复制除最后一个实参以外的所有其他参数,但它的返回结果却总是会与其最后一个实参共享结构

;; 破坏性操作
;; 修改已有对象的操作被称作是破坏性的(destructive)
;; 副作用性(for-side-effect)操作和回收性(recycling)操作
(defparameter *list-1* (list 1 2))
(defparameter *list-2* (list 3 4))
(defparameter *list-3* (append *list-1* *list-2*))

;; 副作用性操作是专门利用其副作用的操作 如setf;和vector-push 或 VEctor-pop这类在底层使用setf来修改已有对象状态的函数
*list-1*
*list-2*
*list-3*
(setf (first *list-2*) 0)

;; 回收性操作 是一种优化手段,在构造结果时会重用来自它们实参的特定对点单元
;; 只有当调用回收性函数之后不再需要原先列表的情况下,回收函数才可以被安全地使用

(setf *list* (reverse *list*))

;; nreverse 函数名中N的含义是non-consing,意思是它不需要分配任何新的对点单元

(setf *list1* (nreverse *list*))
(setf (first *list*) 1)
*list*
*list1*

;; 常用的回收性函数 nconc 是append 的回收性版本
(defparameter *list-1* (list 1 2))
(defparameter *list-2* (list 3 4))
(defparameter *list-3* (nconc *list-1* *list-2*))
*list-1*
*list-2*
*list-3*
(setf (first *list-2*) 0)
(setf (first *list-1*) 0)
;; delete delete-if delete-if-not delete-duplicates 则是序列函数的remove家族的回收性版本
(defparameter *x* (list 1 2 3))
(nconc *x* (list 4 5 6))
*x*

;;nsubstitute 及其变体可靠地沿着列表结构向下遍历,将任何带旧值的点对单元的car部分setf到新值上,否则保持列表原封不动.然后它返回最初的列表,其带有与substitute计算得到的结果相同的值

;; 关于nconc 和 nsubstitute 关键是需要记住,它们是不依赖与回收性函数的副作用这一规则的例外

;; 组合回收性函数和共享结构

;; 回收性函数会有一些习惯用法.其中最常见的一种是构造一个列表,它是由一个在列表前端不断做点对分配操作的函数返回,通常是将元素push进一个保存在局部变量中的列表里,然后返回对其nreverse的结果.
(defun upto(max)
  (let ((result nil))
    (dotimes (i max)
      (push i result))
    (nreverse result)))
(upto 10)

;; 还有一个最常见的回收性函数习惯用法,是将回收性函数的返回值立即重新赋值到含有可能会被回收的值的位置上

(setf foo (delete nil foo))
(defparameter *list-1* (list 1 2))
(defparameter *list-2* (list 3 4))
(defparameter *list-3* (append *list-1* *list-2*))
(setf *list-3* (delete 4 *list-3*))
(setf *list-3* (remove 4 *list-3*))
*list-2*
*list-3*
;; sort ,stable-sort 和 merge 应用于列表时,它们也是回收性函数
(defparameter *list* (list 4 3 2 1))
(sort *list* #'<)
*list*

;; 列表处理函数

;; nth 接受两个参数,一个索引一个列表,并返回列表中的第n个选手
(nth 3 (list 1 2 3 4))
;; nthcdr 接受一个索引和一个列表,并返回调用cdr n次的结果
(nthcdr 2 (list 1 2 3 4 5))

;; 每个函数都是通过将由最多四个A和D组成的序列放在C和D之间来命名,其中每个A代表对CAR的调用而每个D代表对CDR的调用

(caar (list 1 2 3 4 5))
(caar (list (list 1 2) 3))
(car (car (list (list 1 2) 3)))
(cadr (list (list 1 2) (list 3 4)))
(car (cdr (list (list 1 2) (list 3 4))))
(caadr (list (list 1 2) (list 3 4)))
(car (car (cdr (list (list 1 2) (list 3 4)))))

;; |函数|描述|
;; |last|返回列表的最后一个点对单元.带有一个整数参数时,返回最后n个点对单元|
;; |butlast|返回列表的一个副本,最后一个对点单元除外.带有一个整数参数时,排除最后n个单元|
;; |nbutlast|butlast的回收性版本.可能修改并返回其参数列表但缺少可靠的副作用|
;; |ldiff|返回列表直到某个给定点对单元的副本|
;; |tallp|返回真,如果给定对象是作为列表一部分的点对单元|
;; |list*|构造一个列表来保存除最后一个参数外的所有参数,然后让最后一个参数成为这个列表最后一个节点的cdr.换句话说,它组合了list和append|
;; |make-list|构造一个n项的列表.该列表的初始元素是nil或者通过:initial-element关键字参数所指定的值|
;; |revappend|reverse和append的组合.像reverse那样求逆第一个参数,在将其追加到第二参数上|
;; |nreconc|revappend的回收性版本.像nreverse那样那样求逆第一个参数,在将其追加到第二参数上.没有可靠的副作用|
;; |consp|用来测试一个对象是否为点对单元的谓词|
;; |atom|用来测试一个对象不是点对单元的谓词|
;; |listp|用来测试一个对象是否为点对单元或者nil的谓词|
;; |null|用来测试一个对象是否为nill的谓词.功能上等价not但在测试空列表而非布尔假是文体上推荐使用|
(list* 1 2 3 4 5 6)
(last (list 1 2 3 4 5 6 7))

(cons 7 nil)

(car (cons 7 nil))
(cdr (cons 7 nil))

;; 映射

;; mapcar 行为与map的行为相同:函数被应用在列表实参的相继元素上,每次函数的应用会从每个列表中各接受一个元素.每次函数的调用的结果都被收集到一个新列表中
(mapcar #'(lambda (x) (* 2 x)) (list 1 2 3))
(mapcar #'+ (list 1 2 3) (list 10 20 30))
(mapcar #'car '((1 a) (2 b) (3 c)))
(mapcar #'abs '(3 -4 2 -5 -6))
(mapcar #'cons '(a b c) '(1 2 3))
;; maplist 应用于列表的点对单元
(maplist (lambda (x) (list 'start x 'end)) '(1 2 3 4))
(maplist #'append '(1 2 3 4) '(1 2) '(1 2 3))
(maplist #'(lambda (x) (cons 'foo x)) '(a b c d))
(maplist #'(lambda (x) (if (member (car x) (cdr x)) 0 1)) '(a b a c d b c))

;; mapcan
(mapcan #'(lambda (x y) (if (null x) nil (list x y)))
        '(nil nil nil d e)
        '(1 2 3 4 5 6))
(mapcan #'(lambda (x) (and (numberp x) (list x)))
        '(a 1 b c 3 4 d 5))
;; mapcon
(mapcon #'list '(1 2 3 4))


;; mapcan 和 mapcon 与mapcar和maplist 工作方式很相似.
;; mapcar 和 maplist 会构造一个全新的列表来保存函数调用的结果,而mapcan和mapcon则通过将结果(必须是列表)用nconc拼接在一起来产生它们的结果

;; mapc 和 mapl 是伪装成函数的控制结构,它们只返回第一个参数实参
;; mapc
(setq dummy nil)
(mapc #'(lambda (&rest x) (setq dummy (append dummy x)))
      '(1 2 3 4)
      '(a b c d e)
      '(x y z))
dummy
;; mapl
(setq dummy nil)
(mapl #'(lambda (x) (push x dummy)) '(1 2 3 4))
dummy

;; 树

;; copy-list 作为列表函数只复制那些构成列表结构的对点单元
;; copy-tree 会将每个点对单元都生成一个新的点对单元,并将它们以相同的结构连接在一起

;; tree-equal 会比较两颗树,当这两课树具有相同的形状以及它们对应的叶子是eql等价时,函数就认为它们相等

;; subst 接受一个新项,一个旧项和一颗树(和序列的情况刚好相反),以及:key和:test 关键字参数,然后返回一颗与原先的相同形状的新树,只不过其中的所有旧项的实例都被替换成新项
(subst 10 1 '(1 2 (3 2 1) ((1 1) (2 2))))

;; subst-if 接受一个单参数函数而不是一个旧项,该函数在树的每个原子值上都会调用,并且当它返回真时,新树中的对应位置将被填充成新值

;; 集合 (集合变大时,效率会越来越来低效)
;; adjoin 来构造集合。adjoin接受一个项和一个代表集合的列表并返回另一个代表集合的列表，其中含有该项和原先集合中的所有项
;; adjoin 也接受:key 和 :test 关键字参数

(defparameter *set* ())
(adjoin 1 *set*)
(setf *set* (adjoin 1 *set*))
(pushnew 2 *set*)
(pushnew 2 *set*)
*set*

;; member和相关的函数member-if 以及member-if-not 来测试一个给定项是否在一个集合中；当指定项存在时它们并不返回该项，而是返回含有该项的那个点对单元，即以指定项开始的子列表。
(member '3 '(1 2 3))

;; intersection ,union,set-differences以及set-exclusive-or 这些函数中的每一个都接受两个列表以及:key 和 :test 关键字参数,并且返回一个新列表,

;; intersection 返回一个由两个参数中可找到的所有元素组成的列表
(intersection '(1 2 3 4) '(3 4 5 6))
;; union 返回一个列表,其含有来自两个参数的每个唯一元素的一个实例
(union '(1 2 3 4) '(3 4 5 6))
;; set-differences 返回一个列表,其含有来自第一个参数但并不出现在第二个参数中的所有元素
(set-difference '(1 2 3 4) '(3 4 5 6))
;; set-exclusive-or 返回一个列表,其含有仅来自两个参数列表中的一个而不是两者的那些元素
(set-exclusive-or '(1 2 3 4) '(3 4 5 6))

;; subsetp 接受两个列表以及通常的:key和:test关键字参数,并在第一个列表是第二个列表的一个子集是返回真
(subsetp '(3 2 1) '(1 2 3 4))
(subsetp '(1 2 3 4) '(3 2 1))

;; 查询表:alist和plist (不能用于大型表)
;; 关联表 alist
;; 属性表 plist

;; alist 是一种数据结构,它能将一些键映射到值上,同时也支持i反向查询,并且当给定一个值时,它还能找出一个u对应的键
;; 从底层来看,alist本质上是一个列表,其每一元素本身都是一个点对单元.每个元素可以被想象成是一个键值对,其中键保存在点对单元的car中而值保存在cdr中
'((cons a 1) (cons b 2) (cons c 3))

(assoc 'a '((a . 1) (b . 2) (c . 3)))
(assoc 'c '((a . 1) (b . 2) (c . 3)))
(assoc 'd '((a . 1) (b . 2) (c . 3)))
(cdr (assoc 'a '((a . 1) (b . 2) (c . 3))))

(assoc "a" '(("a" . 1) ("b" . 2) ("c" . 3)) :test #'string=)

;; (cons (cons 'new-key 'new-value) alist)
;; (acons 'new-key 'new-value alist)

;; (setf alist (acons 'new-key 'new-value alist))
;; (push (cons 'new-key 'new-value) alist)

(setf alist (acons 'a '2 '((a . 1) (b . 2) (c . 3))))

(push (cons 'd 2) '((a . 1) (b . 2) (c . 3)))

;; assoc 搜索一个alist所花的时间是当匹配对被发现时当前列表深度的函数.在最坏情况下,检测到没有匹配的对将需要assoc扫描alist的每一元素.

;; rassoc 使用每个元素的cdr中的值最为键,从而进行反向查询
(rassoc '1 '((a . 1) (b . 2) (c . 3)))

;; copy-alist 只复制那些构成列表结构的点对单元,外加那些单元的car部分直接引用的点对单元

;; pairlis 从分开的键和值的列表构造一个alist,返回的alist可能含有与原先列表相同或者相反顺序的键值对
(pairlis '(a b c) '(1 2 3))

;; plist 带有交替出现的键和值作为列表中的值。

'(A 1 B 2 C 3)

;; getf 接受一个plist和一个键，返回所关联的值或是键没有被找到时返回nil
(getf '(A 1 B 2 C 3) 'A)

;; getf 总是使用EQ来测试所提供的键是否匹配plist中的键。因此不能用数字和字符作为plist中的键
(defparameter *plist* ())
*plist*
(setf (getf *plist* :a) 1)
(setf (getf *plist* :b) 2)
(setf (getf *plist* :a) 2)
;; remf 移除plist 一个键值对
(remf *plist* :a)

;; get-properties 从单一plist中抽取出多个值

;; (defun process-properties(plist keys)
;;   (loop while plist do
;;        (multiple-value-bind(key value tail)(get-properties plist keys)
;;          (when key (process-property key value))
;;          (setf plist (cddr tail)))))

;; (process-properties '(:a 1 :b 3 :c 4) '(:a :b))

;; get-properties 接受一个plist和一个需要被搜索的键的列表，并返回多个值:第一个被找到的键、其对应的值，以及对应的值，以及一个被找到的键开始的列表的头部
(get-properties '(:a 1 :b 2 :c 4) '(:a :b))

;; get 接受一个符号和一个键，功能相当与在符号的symbol-plist上对同一个键使用getf。
(get 'symbol 'key)
(getf (symbol-plist 'symbol) 'key)

(setf (get 'some-symbol 'mykey) "information")

(remprop 'symbol 'key)
(remf (symbol-plist 'symbol key))

;; destructring-bind 拆分列表的工具,提供了一种解构(destructure)任意列表的方法

;; (destructring-bind (parameter*) list body-form*)

(destructuring-bind (x y z) (list 1 2 3)
  (list :x x :y y :z z))

(destructuring-bind(x y z) (list 1 (list 2 20) 3)
  (list :x x :y  y :z z))

(destructuring-bind(x (y1 y2) z) (list 1 (list 2 20) 3)
  (list :x x :y1 y1 :y2 y2 :z z))

(destructuring-bind(x (y1 &optional y2) z) (list 1 (list 2 20) 3)
  (list :x x :y1 y1 :y2 y2 :z z))

(destructuring-bind(x (y1 &optional y2) z) (list 1 (list 2) 3)
  (list :x x :y1 y1 :y2 y2 :z z))

(destructuring-bind(&key x y z) (list :x 1 :y 2 :z 3)
  (list :x x :y y  :z z))

(destructuring-bind(&key x y z) (list :z 1 :y 2 :x 3)
  (list :x x :y y  :z z))

;; &whole 必须是参数列表中的第一个参数,并且他会绑定到整个列表形式上
(destructuring-bind (&whole whole &key x y z) (list :z 1 :y 2 :x 3)
  (list :x x :y y :z z :whole whole))

;; 文件和文件I/O

;; 读取文件数据
(open "./name.txt")

;; open 返回一个基于字符的输入流
;; read-char 读取单个字符
;; read-line 读取一行文本,去掉结束字符后作为一个字符串返回
;; read 读取单元的S-表达式并返回一个lisp对象
;; close 关闭流

;; 打印文件的第一行
(let ((in (open "name.txt")))
  (format t "~a~%" (read-line in))
  (close in))

;; 使用关键字:if-does-not-exist 来指定不同的行为.三个可能的值是 :error,报错(默认值);:create,来继续进行并创建该文件,然后就像它已经存在那样进行处理;NIL,让它返回NIL来代替一个流.

(let ((in (open "name.txt" :if-does-not-exist nil)))
  (when in
    (format t "~a~%" (read-line in))
    (close in)))
;; 读取函数.即read-char,read-line和read,都接受一个可选的参数,其默认值为真并指定当函数在文件结尾处被调用是是否应该报错.如果该参数为nil,它们在遇到文件结尾是将返回它们的第三个参数的值,默认为nil

(let ((in (open "name.txt" :if-does-not-exist nil)))
  (when in
    (loop for line = (read-line in nil)
       while line do (format t "~a~%" line))
    (close in)))

;; 读取二进制数据
;; 向open传递一个值为 '(unsigned-byte 8) 的:element-type 参数
;; read-byte 将在被调用是返回0~255的整数
(let ((in (open "name.txt" :if-does-not-exist nil :element-type '(unsigned-byte 8))))
  (when in
    (loop for line = (read-byte in nil)
       while line do (format t "~a~%" line))
    (close in)))

;; 批量读取

;; read-sequence 可同时工作在字符和二进制流上;传递一个序列(通常是一个向量)和一个流,然后会将用流的数据填充该序列

;; 文件输出

;; 调用open是使用一个值为:output的:direction关键字参数来获取它。但打开一个用于输出的文件时，open会假设该文件不该存在并会在会在文件存在是报错。但可以使用:if-exists关键字参数来改变该行为。传递值:supersede可以告诉open来替换已有文件。传递:append将导致open打开已有的文件并保证新数据被写到结尾处，而:overwritte返回一个从文件开始处的开始的流从而覆盖已有的数据。而传递NIL将导致open在文件已存在时返回NIL而不是流。
(open "./name.txt" :direction :output :if-exists :supersede)

;; write-char 向流中写入一个单一字符；
;; write-line 向一个字符串并紧跟一个换行，其将被输出成用于当前平台的适当行结束字符或字符序列
;; write-string 写一个字符串而不会添加任何行结束符

;; 打印一个换行：
;; TERPRI 是 "终止打印"(terminate print)的简称,即无条件地打印一个换行字符;
;; FRESH-LINE 打印一个换行字符,除非该流已经在一行的开始处

(let ((ou (open "name.txt" :direction :output :if-exists :supersede)))
  (write-line "123456" ou)
  (write-string "123456" ou)
  (terpri ou)
  (write-string "123456" ou)
  (write-string "123456" ou)
  (fresh-line ou)
  (write-line "123456" ou)
  (close ou))
;; print 打印一个S-表达式,前缀一个换行及一个空格;
;; prin1 只打印S-表达式
;; pprint 美化打印器

;; princ 打印lisp对象

;; 写入二进制数据,在使用open打开文件时带有与读取该文件时相同的:element-type的实参,其值为'(unsigned-byte 8),然后使用write-byte向流中写入单独的字节
;; write-sequence 可以同时接受二进制和字符流

;; 关闭文件
(let ((steam (open "name.txt")))
  ;; do stuff with strem
  (close stream))

;; (with-open-file (steam-var open-argument*)
;;   body-form*)



(with-open-file (stream "name.txt")
  (format t "~a~%" (read-line stream)))

(with-open-file (stream "name.txt" :direction :output :if-exists :supersede)
  (format stream "Some text."))


(with-open-file (stream "name.txt" :direction :output :if-exists :supersede)
  (format stream "Some text. 1234566"))


;; 文件名

;; 路径名是一种使用6个组件来表示文件名的结构化对象:主机(host),设备(device),目录(directory),名称(name),类型(type)以及版本(version)

;; pathname 将名字字符串转化成路径名;接受路径名描述符并返回等价的路径名对象

(pathname "name.txt")

(pathname-directory (pathname "name.txt"))
(pathname-name (pathname "name.txt"))
(pathname-type (pathname "name.txt"))
(pathname-version (pathname "name.txt"))
(pathname-host (pathname "name.txt"))
(pathname-device (pathname "name.txt"))

;; 在window上,pathname-host 和 pathname-device 两者之一将返回驱动器字母

;; namestring 接受一个路径名描述符并返回一个名字字符串
(namestring #p"name.txt")
;; directory-namestring 将目录组件的元素组合成一个本地目录名
(directory-namestring #p"name.txt")
;; file-namestring 组合名字和类型组件
(file-namestring #p"name.txt")

;; 构造新路径名
;; make-pathname 构造任意路径名
(make-pathname
 :directory '(:absolute :home "workspace" "self" "lisp-demo")
 :name "name"
 :type "txt")


(setf input-file (make-pathname
                  :directory '(:absolute :home "workspace" "self" "lisp-demo")
                  :name "name"
                  :type "txt"))
(make-pathname :type "html" :name "index" :defaults input-file)

(make-pathname :directory '(:relative "backups") :defaults input-file)

;; merge-pathname 合并两个路径名的目录组件来组合两个路径名,其中至少一个带有相对的目录组件.

;; merge-pathnames 接受两个路径名并合并它们,用来自第二路径名的对应值填充第一个路径名中的任何NIL组件
(merge-pathnames #p"foo/bar.html" #p"html/")
(merge-pathnames #p"foo/bar.html" #p"/www/html/")

;; enough-namestring 获取一个相对于特定根目录的文件名
(enough-namestring #p"/www/html/foo/bar.html" #p"/www/")

;;enough-namestring 和 member-pathnames 来创建一个表达相同名称但却在不同根目录中的路径名
(merge-pathnames
 (enough-namestring #p"/www/html/foo/bar/baz.html" #p"/www/")
 #p"/www-backups/")

;; merger-pathnames 也被用来实际访问文件系统中标准函数内部用于填充不完全的路径名的文件

;; common lisp 通过合并给定路径名与变量*default-pathname-defaults*中的值来获取缺失组件的值
*default-pathname-defaults*
(make-pathname :name "foo" :type "txt")

;; 目录名的两种表示方法
