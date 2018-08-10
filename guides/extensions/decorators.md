# Decorators

<!-- TODO:
  An article about decorators doesn't really belong in the `/extensions`
  directory. In the future, there will be a better home for it.
-->

Solidus autoloads any file in the `/app` directory that has the suffix
`_decorator.rb`, just like any other Rails models or controllers. This allows
you to [monkey patch][monkey-patch] Solidus functionality for your store.

For example, if you want to add a method to the `Spree::Order` model, you could
create `/app/models/mystore/order_decorator.rb` with the following contents:

```ruby
module MyStore
  module OrderDecorator
    def total
      super + BigDecimal(10.0)
    end
  end
end

Spree::Order.prepend MyStore::OrderDecorator
```

This creates a new module called `MyStore::OrderDecorator` that prepends its
methods early in the method lookup chain. So, for method calls on `Spree::Order`
objects, the decorator's `total` method would override the original `total`
method.

From now on, every order, when asked for its total, returns an inflated
total by $10 (or whatever your currency is).

[monkey-patch]: https://en.wikipedia.org/wiki/Monkey_patch

## Decorators and Solidus upgrades

Decorators can complicate your Solidus upgrades. If you depend on decorators,
ensure that you test them before upgrading in a production environment.
Note that Solidus's core classes may change with each release.
