# Workshop Ruby: C Extension

L'objectif de ce workshop est d'étendre les fonctionnalités du langage Ruby
en créant une interface entre la syntaxe Ruby et un code préexistant en
langage C.

## Installer Ruby

Pour utiliser Ruby, il suffit d'installer la dernière version avec le
[https://rvm.io](Ruby Version Manager).

Cette installation vous donnera accès au REPL ruby `irb`, à l'interpréteur
`ruby` et au package manager `gem`.

## Installer les dépendances de ce projet et compiler

```shell
gem install bundle
cd workshop-ruby-c-extension/
bundle install
bundle exec rake
# => ./lib/hello_c.so
```

## Avec le Gemfile

```shell
gem build
# => workshop-ruby-c-extension-0.1.0.gem
gem install workshop-ruby-c-extension-0.1.0.gem
```

## Tester l'extension

```ruby
require 'hello_c'
HelloC.world
# => 'Hello, World!'
```

## Votre objectif

Plusieurs objectifs sont possibles. En voici quelques exemples:

- Vous familiariser avec l'ecosystème Ruby, notamment les Rakefiles, les modules
- En vous inspirant de [ce repo](https://github.com/kanwei/algorithms), créez une extension à partir de votre propre code C.

## Conseils

- Identifiez le chemin vers le header `ruby.h` et ajoutez le à votre IDE afin de disposer de la complétion.
- N'hésitez pas à consulter directement le code source Ruby, dont un miroir est présent [ici](https://github.com/ruby/ruby).
- Recherchez des exemples de code précis sur [Code Search](https://cs.github.com) ou dans des tutoriels.
- Obtenez une copie PDF de Ruby Under a Microscope

## Explorer le code source de Ruby

Voici un exemple avec l'implémentation de `Array#count`.

```ruby
[1, 2, 3, 2].count 2
# => 2
```

Le code se trouve dans [array.c](https://github.com/ruby/ruby/blob/master/array.c#L6053).

Voici une version commentée par moi:

```c
static VALUE
rb_ary_count(int argc, VALUE *argv, VALUE ary)
{
    long i, n = 0;

    /*
    Selon la documentation officielle,
    >Check the number of arguments, argc is in the range of min..max.  If
    max is UNLIMITED_ARGUMENTS, upper bound is not checked.  If argc is
    out of bounds, an ArgumentError will be raised.
    */
    if (rb_check_arity(argc, 0, 1) == 0) {
	VALUE v;


    /*
    En ruby, une méthode peut être appelée avec un *bloc*:

    [1, 2, 3].count { |value| value == 3 || value == 2 }
    # => 2

    !rb_block_given_p() vérifie l'absence d'un tel bloc dans les arguments.
    */
	if (!rb_block_given_p())
	    return LONG2NUM(RARRAY_LEN(ary));

    /*
    Si un bloc a été passé, on incrémente n à chaque fois que bloc(element)
    renvoi une valeur vraie. On éxecute un bloc avec rb_yield(v), où v est
    un taleau d'arguments.
    */
	for (i = 0; i < RARRAY_LEN(ary); i++) {
	    v = RARRAY_AREF(ary, i);
	    if (RTEST(rb_yield(v))) n++;
	}
    }
    else {
        VALUE obj = argv[0];

    /*
    Si des arguments on été passés en plus d'un bloc, on ignore le bloc
    */
	if (rb_block_given_p()) {
	    rb_warn("given block not used");
	}

    /*
    On compare chaque élément du tableau avec le premier argument passé à count
    */
	for (i = 0; i < RARRAY_LEN(ary); i++) {
	    if (rb_equal(RARRAY_AREF(ary, i), obj)) n++;
	}
    }

    return LONG2NUM(n);
}

// ...
    rb_define_method(rb_cArray, "count", rb_ary_count, -1);
```

Cette méthode se comporte de manière différente suivant le nombre et le type des arguments
qui lui sont passé. Beaucoup de macros et de types sont accessibles via `ruby.h` afin que
les extensions C aient les même capacités que le langage lui-même.
