# Documentation

Just an example documentation.
This text goes in the top of the page.
## person

Person library.

This library is just an example for documentation.

### Person

```nelua
global Person = @record{
  name: string, -- Full name.
  age: integer, -- Years since birth.
}
```

Person record.

### Person.create

```nelua
function Person.create(name: string, age: integer): *Person
```

Creates a new person with `name` and `age`.

### Person:get_name

```nelua
function Person:get_name(): string
```

Returns the person name.

### Person:get_age

```nelua
function Person:get_age(): integer
```

Returns the person age.

---

You have reached the end of the documentation!
