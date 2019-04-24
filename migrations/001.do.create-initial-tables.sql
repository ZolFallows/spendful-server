
--
-- updated_at setter function
--

CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--
-- Users Table
--

DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
  full_name TEXT NOT NULL,
  email_address TEXT NOT NULL,
  password_hash TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TRIGGER users_updated_at
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE PROCEDURE set_updated_at();

--
-- Categories Table
--

DROP TYPE IF EXISTS transaction_type;

CREATE TYPE transaction_type AS ENUM ('income', 'expense');

DROP TABLE IF EXISTS categories;

CREATE TABLE categories (
  id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
  owner_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  type transaction_type NOT NULL,
  monthly_budget NUMERIC(12, 2),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TRIGGER categories_updated_at
BEFORE UPDATE ON categories
FOR EACH ROW
EXECUTE PROCEDURE set_updated_at();


--
-- Incomes Table
--

DROP TABLE IF EXISTS incomes;

CREATE TABLE incomes (
  id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
  owner_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  category_id INTEGER REFERENCES categories(id) ON DELETE RESTRICT,
  description TEXT NOT NULL,
  amount NUMERIC(12, 2) NOT NULL,
  recurring_rule TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TRIGGER incomes_updated_at
BEFORE UPDATE ON incomes
FOR EACH ROW
EXECUTE PROCEDURE set_updated_at();

--
-- Expenses Table
--

DROP TABLE IF EXISTS expenses;

CREATE TABLE expenses (
  id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
  owner_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  category_id INTEGER REFERENCES categories(id) ON DELETE RESTRICT,
  description TEXT NOT NULL,
  amount NUMERIC(12, 2) NOT NULL,
  recurring_rule TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TRIGGER expenses_updated_at
BEFORE UPDATE ON expenses
FOR EACH ROW
EXECUTE PROCEDURE set_updated_at();
