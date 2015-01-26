require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def test_auth
    assert_equal users(:bob), User.authenticate("bob@test.com", "atest")
    assert_nil User.authenticate("nonbob", "atest")
  end

  def test_passwordchange
    users(:longbob).change_password("nonbobpasswd")
    users(:longbob).save
    assert_equal users(:longbob), User.authenticate("longbob@test.com", "nonbobpasswd")
    assert_nil User.authenticate("longbob@test.com", "alongtest")
    users(:longbob).change_password("alongtest")
    users(:longbob).save
    assert_equal users(:longbob), User.authenticate("longbob@test.com", "alongtest")
    assert_nil User.authenticate("longbob@test.com", "nonbobpasswd")
  end

  def test_disallowed_passwords
    u = User.new
    u.email = 'tesla.yaginuma@test.com'

    u.change_password("tiny")
    assert !u.save
    assert u.errors[:password]

    u.change_password("hugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehuge")
    assert !u.save
    assert u.errors[:password]

    u.change_password("")
    assert !u.save
    assert u.errors[:password]

    u.change_password("bobs_secure_password")
    assert u.save
    assert u.errors.empty?
  end

  def test_bad_logins
    u = User.new
    u.email = 'bob@test.com'
    u.change_password('bobs_secure_password')

    assert !u.save
    assert u.errors[:email].first

    u.email = 'hugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhug'
    assert !u.save
    assert u.errors[:email].first

    u.email = ''
    assert !u.save
    assert u.errors[:email].first

    u.email = 'okbob@test.com'
    assert u.save
    assert u.errors.empty?
  end

  def test_collision
    u = User.new
    u.email = 'bob@test.com'
    u.change_password('bobs_secure_password')
    assert !u.save
  end

  def test_create
    u = User.new
    u.email = 'tesla.yaginuma@test.com'
    u.change_password("bobs_secure_password")

    assert u.save
  end

end
